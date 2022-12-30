import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:musico/widgets/file_select/file_bean.dart';

typedef bool CanAccept<T>(int oldIndex, int newIndex, List<T> data);

typedef Widget DataWidgetBuilder<T>(BuildContext context, T data);

class SortableGridView<T extends Object> extends StatefulWidget {
  const SortableGridView(
    this.dataList, {
    Key? key,
    this.scrollDirection = Axis.vertical,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1.0,
    required this.itemBuilder,
    required this.canAccept,
  })  : assert(itemBuilder != null),
        assert(canAccept != null),
        assert(dataList != null && dataList.length >= 0),
        super(key: key);

  //用于生成GridView的Item Widget的函数，接收一个context参数和一个数据源参数，返回一个Widget
  final DataWidgetBuilder<T> itemBuilder;
  final CanAccept<T> canAccept; //是否接受拖拽过来的数据的回调函数
  final List<T> dataList; //数据源List
  final Axis scrollDirection; //GridView的滚动方向
  //非主轴方向的item数量，即 如果GridView的滚动方向是垂直方向，那么这个字段的意思就是有多少列；如果为水平方向，则此字段代表有多少行。
  final int crossAxisCount;
  //每个Item的宽高比，由于GridView的Item默认是正方形的，可以通过这个比例稍作调整。可能会有我不知道的别的办法。
  final double childAspectRatio;

  @override
  State<SortableGridView<T>> createState() => _SortableGridViewState<T>();
}

class _SortableGridViewState<T extends Object>
    extends State<SortableGridView<T>> {
  late List<T> _dataList; //数据源
  late List<T>
      _dataListBackup; //数据源备份，在拖动时 会直接在数据源上修改 来影响UI变化，当拖动取消等情况，需要通过备份还原
  bool _showItemWhenCovered = false; //手指覆盖的地方，即item被拖动时 底部的那个widget是否可见；
  int _willAcceptIndex = -1; //当拖动覆盖到某个item上的时候，记录这个item的坐标
//  int _draggingItemIndex = -1; //当前被拖动的item坐标
//  ScrollController _scrollController;//当item数量超出屏幕 拖动Item到底部或顶部 可使用ScrollController滚动GridView 实现自动滚动的效果。

  @override
  void initState() {
    super.initState();
//    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
//    _scrollController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _dataList = widget.dataList;
    _dataListBackup = _dataList.sublist(0);
    return GridView.count(
//      controller: _scrollController,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      childAspectRatio: widget.childAspectRatio, //item宽高比
      scrollDirection: widget.scrollDirection, //默认vertical
      crossAxisCount: widget.crossAxisCount, //列数
      children: _buildGridChildren(context),
    );
  }

  //生成widget列表
  List<Widget> _buildGridChildren(BuildContext context) {
    final list = <Widget>[];
    for (var x = 0; x < _dataList.length; x++) {
      list.add(_buildDraggable(context, x));
    }
    return list;
  }

  //绘制一个可拖拽的控件。
  Widget _buildDraggable(BuildContext context, int index) {
    var item = _dataList[index];
    if (item is FileBean) {
      FileBean info = item;
      if (!(info.isImage ?? false) || ObjectUtil.isEmpty(info.mediaId ?? '')) {
        return widget.itemBuilder(context, _dataList[index]);
      }
    }
    return LayoutBuilder(
      builder: (context, constraint) {
        return LongPressDraggable<T>(
          data: item,
          onDragStarted: () {
            //开始拖动，备份数据源
//            _draggingItemIndex = index;
            _dataListBackup = _dataList.sublist(0);
            print('item $index ---------------------------onDragStarted');
          },
          onDraggableCanceled: (Velocity velocity, Offset offset) {
            print(
                'item $index ---------------------------onDraggableCanceled,velocity = $velocity,offset = $offset');
            //拖动取消，还原数据源
            setState(() {
              _willAcceptIndex = -1;
              _showItemWhenCovered = false;
              _dataList = _dataListBackup.sublist(0);
              widget.canAccept(index, index, _dataList);
            });
          },
          onDragCompleted: () {
            //拖动完成，刷新状态，重置willAcceptIndex
            print("item $index ---------------------------onDragCompleted");
            print(
                "item $index $_willAcceptIndex ---onDragCompleted---${_dataList.toString()}");
            widget.canAccept(index, _willAcceptIndex, _dataList);
            setState(() {
              _showItemWhenCovered = false;
              _willAcceptIndex = -1;
            });
          },
          //用户拖动item时，那个给用户看起来被拖动的widget，（就是会跟着用户走的那个widget）
          feedback: SizedBox(
            width: constraint.maxWidth * 0.95,
            height: constraint.maxHeight * 0.95,
            child: widget.itemBuilder(context, _dataList[index]),
          ),
          //这个是当item被拖动时，item原来位置用来占位的widget，（用户把item拖走后原来的地方该显示啥？就是这个）
          childWhenDragging: Container(
            child: SizedBox(
              child: _showItemWhenCovered
                  ? widget.itemBuilder(context, _dataList[index])
                  : null,
            ),
          ),
          child: DragTarget<T>(
            //松手时 如果onWillAccept返回true 那么久会调用，本案例不使用。
            onAccept: (T data) {
              print('----------- onAccept  index = $data');
            },
            //绘制widget
            builder: (context, data, rejects) {
              return _willAcceptIndex >= 0 && _willAcceptIndex == index
                  ? const SizedBox.shrink()
                  : widget.itemBuilder(context, _dataList[index]);
            },
            //手指拖着一个widget从另一个widget头上滑走时会调用
            onLeave: (data) {
              print('----------- onLeave  index = $data');

              //TODO 这里应该还可以优化，当用户滑出而又没有滑入某个item的时候 可以重新排列  让当前被拖走的item的空白被填满
              _willAcceptIndex = -1;
              setState(() {
                _showItemWhenCovered = false;
                _dataList = _dataListBackup.sublist(0);
              });
            },
            //接下来松手 是否需要将数据给这个widget？  因为需要在拖动时改变UI，所以在这里直接修改数据源
            onWillAccept: (T? fromData) {
              if (fromData == null) return false;
              if (!_dataList.contains(fromData)) return false;

              ///是否接受
              bool accept = fromData != index;

              ///判断是否接受
              var toItem = _dataList[index];
              if (toItem is FileBean) {
                FileBean info = toItem;
                if (!(info.isImage ?? false) ||
                    ObjectUtil.isEmpty(info.mediaId ?? '')) {
                  accept = false;
                }
              }
              if (accept) {
                _willAcceptIndex = index;
                _showItemWhenCovered = true;
                _dataList = _dataListBackup.sublist(0);
                //final fromData = _dataList[fromIndex];
                setState(() {
                  _dataList.remove(fromData);
                  _dataList.insert(index, fromData);
                });
              }
              return accept;
            },
          ),
        );
      },
    );
  }
}
