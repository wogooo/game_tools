package com.dolo.ui.controls
{
	import com.dolo.ui.events.UIEvent;
	import com.dolo.ui.managers.UI;
	import com.dolo.ui.renders.IListRender;
	import com.dolo.ui.renders.ITreeRender;
	import com.dolo.ui.renders.TreeNodeRenderBase;
	import com.dolo.ui.renders.TreeTrunkRenderBase;
	import com.dolo.ui.tools.Align;
	import com.dolo.ui.tools.AutoBuild;
	import com.dolo.ui.tools.TreeSprite;
	import com.dolo.ui.tools.Xdis;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;

	/**
	 * 双层自定义树干和树枝渲染器树 
	 * @author flashk
	 * 
	 */
	public class DoubleDeckTree extends UIComponent
	{
		public static var defaultScrollBarXAdd:int = 6;
		public static var scrollRectLess:int = 6;
		
		protected var _canTrunkSelect:Boolean = false;
		protected var _renderContainerClass:Class;
		protected var _trunkRender:Class;
		protected var _nodeRender:Class;
		protected var _scrollBar:VScrollBar;
		protected var _selectedTrunkIndex:int = -1;
		protected var _selectedIndex:int = -1;
		protected var _selectedItem:Object;
		protected var _ui:Sprite;
		protected var _renderContainer:Sprite;
		protected var _bg:DisplayObject;
		protected var _lastSelect:ITreeRender;
		protected var _lastSelectTrunk:ITreeRender;
		protected var _isUserClick:Boolean = false;
		protected var _trunkDefaultOpen:Boolean = false;
		protected var _last:Array = [];
		
		override public function dispose():void
		{
			super.dispose();
			_renderContainerClass = null;
			_trunkRender = null;
			_nodeRender = null;
			_scrollBar = null;
			_selectedItem = null;
			_ui = null;
			_renderContainer = null;
			_bg = null;
			_lastSelect = null;
			_lastSelectTrunk = null;
			_last = null;
		}
		
		public function DoubleDeckTree()
		{
			_renderContainerClass = TreeSprite;
			_trunkRender = TreeTrunkRenderBase;
			_nodeRender = TreeNodeRenderBase;
			_renderContainer = new Sprite();
			this.addChild( _renderContainer );
		}

		public function get canTrunkSelect():Boolean
		{
			return _canTrunkSelect;
		}

		/**
		 * 树干是否可以被选中，此时树枝将被取消选中，并派发 UIEvent.TREE_TRUNK_CHANGE事件,
		 * selectIndex将被设置为-1,_selectedTrunkIndex为当前树干位置
		 * @param value
		 * 
		 */
		public function set canTrunkSelect(value:Boolean):void
		{
			_canTrunkSelect = value;
		}

		public function get renderContainer():Sprite
		{
			return _renderContainer;
		}

		public function get scrollBar():VScrollBar
		{
			return _scrollBar;
		}

		public function get trunkDefaultOpen():Boolean
		{
			return _trunkDefaultOpen;
		}

		public function set trunkDefaultOpen(value:Boolean):void
		{
			_trunkDefaultOpen = value;
		}

		public function get isUserClick():Boolean
		{
			return _isUserClick;
		}

		public function set isUserClick(value:Boolean):void
		{
			_isUserClick = value;
		}

		public function get selectedTrunkIndex():int
		{
			if( _lastSelect ){
				return ITreeRender( _lastSelect ).trunkIndex;
			}
			if( _lastSelectTrunk ){
				return ITreeRender( _lastSelectTrunk ).trunkIndex;
			}
			return -1;
		}

		public function set selectedTrunkIndex(value:int):void
		{
			_selectedTrunkIndex = value;
			var sp:TreeSprite = _renderContainer.getChildAt( _selectedTrunkIndex ) as TreeSprite;
			_lastSelectTrunk = ITreeRender( sp.getChildAt( 0 ) );
		}

		public function get renderContainerClass():Class
		{
			return _renderContainerClass;
		}

		public function set renderContainerClass(value:Class):void
		{
			_renderContainerClass = value;
		}
		
		/**
		 * 树干的Item 
		 * @return 
		 * 
		 */		
		public function get selectTrunkItem():Object
		{
			if( _lastSelectTrunk ){
				return _lastSelectTrunk.data;
			}
			return null;
		}
		
		public function get selectTrunkIndex():int
		{
			if( _lastSelectTrunk ){
				return _lastSelectTrunk.trunkIndex;
			}
			return -1;
		}

		/**
		 * 节点（树枝）的Item 
		 * @return 
		 * 
		 */		
		public function get selectedItem():Object
		{
			return _selectedItem;
		}

		public function set selectedItem(value:Object):void
		{
			_selectedItem = value;
		}

		public function get selectedIndex():int
		{
			if( _lastSelect ){
				return ITreeRender( _lastSelect ).nodeIndex;
			}
			return -1;
		}
		
		public function get trunkLength():int
		{
			return _renderContainer.numChildren;
		}
		
		public function selectNextAbleSelect(fromTrunk:int = -1,fromNode:int = -1):void
		{
			if( fromTrunk < 0 ) {
				fromTrunk = 0;
			}
			var len:int = trunkLength;
			for( var i:int=fromTrunk; i<len; i++ ){
				for(var j:int=0;j<getNodeLength(i);j++){
					if( j > fromNode || i != fromTrunk ){
						selectedTrunkIndex = i;
						selectedIndex = j;
						return;
					}
				}
			}
		}
		
		/**
		 * 清除列表中当前所选的项目，并将 selectedIndex 属性设置为 -1。 
		 * 
		 */
		public function clearSelection(isDispathEvent:Boolean=true):void
		{
			if( _lastSelect ){
				_lastSelect.select = false;
			}
			if( _lastSelectTrunk ){
				_lastSelectTrunk.select = false;
			}
			if( isDispathEvent == true ){
				this.dispatchEvent( new Event( Event.CHANGE ) );
			}
		}

		public function set selectedIndex(value:int):void
		{
			if( value < -1 ) {
				value = -1;
			}
			_selectedIndex = value;
			if( _lastSelect ){
				_lastSelect.select = false;
			}
			if( _lastSelectTrunk ){
				_lastSelectTrunk.select = false;
			}
			if( value == -1 ) {
				_lastSelect = null;
				return;
			}
			if( _selectedTrunkIndex == -1 ) return;
			var sp:TreeSprite = _renderContainer.getChildAt( _selectedTrunkIndex ) as TreeSprite;
			var render:ITreeRender = sp.getChildAt( value + 1 ) as ITreeRender;
			_lastSelect = render;
			_lastSelect.select = true;
			_selectedItem = render.data;
			this.dispatchEvent( new Event( Event.CHANGE ) );
			if( _isUserClick == true ){
				this.dispatchEvent( new UIEvent( UIEvent.USER_CHANGE ) );
			}
			if( _isUserClick && _last.length > 0 ){
				if( _selectedTrunkIndex == _last[0] && _selectedIndex == _last[1] && getTimer()-_last[2] < UIComponent.doubleClickSpaceTime ){
					this.dispatchEvent( new UIEvent( UIEvent.USER_ITEM_DOUBLE_CLICK ) );
				}
			}
			_last = [ _selectedTrunkIndex, _selectedIndex, getTimer() ];
			_isUserClick = false;
		}
		
		public function get nodeRender():Class
		{
			return _nodeRender;
		}

		public function set nodeRender(value:Class):void
		{
			_nodeRender = value;
		}

		public function get trunkRender():Class
		{
			return _trunkRender;
		}

		public function set trunkRender(value:Class):void
		{
			_trunkRender = value;
		}
		
		/**
		 * 打开某个树干
		 * @param index：树干序号，从0开始
		 * @param isOpen：打开还是关闭
		 * @param isDispatch：打开或关闭发不发事件UIEvent.TREE_TRUNK_CHANGE
		 * 
		 */		
		public function openTrunk(index:int,isOpen:Boolean = true,isDispatch:Boolean=true):void
		{
			if( index < 0 ) return;
			if( index >= _renderContainer.numChildren ) return;
			var sp:TreeSprite = _renderContainer.getChildAt( index ) as TreeSprite;
			sp.isOpen = isOpen;
			if( _canTrunkSelect == true ){
				ITreeRender( sp.getChildAt( 0 )).select = true;
				selectedIndex = -1;
				_lastSelectTrunk = ITreeRender( sp.getChildAt( 0 ) );
				if(isDispatch)
					this.dispatchEvent( new UIEvent( UIEvent.TREE_TRUNK_CHANGE ) );
			}
			onStageRender();
		}
		
		public function setTrunkSelect(trunkIndex:int,isDispathEvent:Boolean=true):void
		{
			if( trunkIndex < 0 ) return;
			if( trunkIndex >= _renderContainer.numChildren ) return;
			_selectedTrunkIndex = trunkIndex;
			var sp:TreeSprite = _renderContainer.getChildAt( trunkIndex ) as TreeSprite;
			sp.isOpen = false;
			if( _canTrunkSelect == true ){
				ITreeRender( sp.getChildAt( 0 ) ).select = true;
				selectedIndex = -1;
				_lastSelectTrunk = ITreeRender(sp.getChildAt(0));
				if( isDispathEvent ){
					this.dispatchEvent( new UIEvent( UIEvent.TREE_TRUNK_CHANGE ) );
				}
			}
			onStageRender ();
		}
		
		public function isTrunkOpen(index:int):Boolean
		{
			if( index < 0 ) return false;
			if( index >= _renderContainer.numChildren ) return false;
			var sp:TreeSprite = _renderContainer.getChildAt( index ) as TreeSprite;
			return sp.isOpen;
		}
		
		/**
		 * 查找某个数据的索引 
		 * @param data 要验证匹配的数据
		 * @param fieldName 如果要查找的数据是item对象的子属性，fieldName为不为空的属性名，如果为空，直接验证匹配item Object
		 * @return  查找到的位置(分别是树干和树枝的序号)，如果没有找到，返回-1
		 * 
		 */
		public function findDataIndex(data:*,fieldName:String=""):Array
		{
			var len:int = trunkLength;
			for( var i:int=0; i<len; i++){
				var nodeLen:int = getNodeLength( i );
				for( var j:int=0; j<nodeLen; j++ ){
					var render:ITreeRender = getNodeRenderAt( i, j ) as ITreeRender;
					if( fieldName == "" ){
						if( render && render.data == data ){
							return [ i, j ];
						}
					}else{
						if( render && render.data[ fieldName ] == data ){
							return [ i, j ];
						}
					}
				}
			}
			return [ -1, -1 ];
		}
		
		public function scrollToNode(node:Object):void
		{
			var len:int = _renderContainer.numChildren;
			for( var i:int=0; i<len; i++ ){
				var sp:Sprite = _renderContainer.getChildAt( i ) as Sprite;
				var render:ITreeRender;
				var nodeLen:int = sp.numChildren;
				for( var j:int=1; j<nodeLen; j++ ){
					render = sp.getChildAt( j ) as ITreeRender;
					if( render ){
						if( render.data == node ){
								scrollToPixelPosition( sp.y + DisplayObject( render ).y );
						}
					}
				}
			}
		}
		
		public function scrollToTrunk(trunkData:Object):void
		{
			var len:int = _renderContainer.numChildren;
			for( var i:int=0; i<len; i++ ){
				var sp:Sprite = _renderContainer.getChildAt( i ) as Sprite;
				var render:ITreeRender;
					render = sp.getChildAt( 0 ) as ITreeRender;
					if( render ){
						if( render.data == trunkData ){
							scrollToPixelPosition( sp.y );
						}
				}
			}
		}
		
		public function scrollToPixelPosition(pos:int):void
		{
			_scrollBar.scrollToPosition( pos );
		}
		
		public function addTrunk(data:Object):void
		{
			addTrunkAt( data, _renderContainer.numChildren );
		}
		
		/**
		 * 在指定位置添加一个树干 
		 * @param data
		 * @param index
		 * 
		 */
		public function addTrunkAt(data:Object,index:int):void
		{
			var tr:DisplayObject = new _trunkRender();
			var sp:TreeSprite = new _renderContainerClass( this );
			sp.addChild( tr );
			sp.update();
			_renderContainer.addChildAt( sp, index );
			ITreeRender( tr ).tree = this;
			ITreeRender( tr ).index = index;
			ITreeRender( tr ).data = data;
			updateTrees();
			if( _selectedTrunkIndex >= index ){ 
				_selectedTrunkIndex ++;
			}
			UI.stage.invalidate();
			UI.stage.addEventListener( Event.RENDER, onStageRender );
		}
		
		public function removeTrunkAt(index:int):Boolean
		{
			var sp:TreeSprite;
			sp = _renderContainer.getChildAt( index ) as TreeSprite
			_renderContainer.removeChild( sp );
			sp.dispose();
			updateTrees();
			if( _selectedTrunkIndex == index ){
				_lastSelect = null;
			}
			UI.stage.invalidate();
			UI.stage.addEventListener( Event.RENDER, onStageRender );
			return true;
		}
		
		private function updateOneTree(sp:Sprite):void
		{
			if( sp.numChildren > 0 ){
				var nodeLen:int = sp.numChildren;
				for( var j:int=1; j<nodeLen; j++ ){
					ITreeRender( sp.getChildAt( j ) ).index = j - 1;
				}
			}
		}
		
		private function updateTrees():void
		{
			var sp:TreeSprite;
			var len:int= _renderContainer.numChildren;
			for( var i:int=0; i<len; i++ ){
				sp = _renderContainer.getChildAt( i ) as TreeSprite;
				if( sp.numChildren > 0 ){
					ITreeRender( sp.getChildAt( 0 ) ).index = i;
					var nodeLen:int = sp.numChildren;
					for( var j:int=0; j<nodeLen; j++ ){
						ITreeRender( sp.getChildAt( j ) ).trunkIndex = i;
					}
				}
			}
		}
		
		/**
		 * 添加节点 
		 * @param data
		 * @param trunkIndex 树干的索引（树干的索引从0开始）
		 * 
		 */
		public function addNote(data:Object,trunkIndex:int):void
		{
			addNoteAt( data, trunkIndex, getNodeLength( trunkIndex ) );
		}
		
		/**
		 * 获得某个树干下有多少个子节点 
		 * @param trunkIndex
		 * @return 
		 * 
		 */
		public function getNodeLength(trunkIndex:int):int
		{
			if( trunkIndex < 0 ) return 0;
			if( trunkIndex >= _renderContainer.numChildren ) return 0;
			var sp:TreeSprite = _renderContainer.getChildAt( trunkIndex ) as TreeSprite;
			return sp.numChildren-1;
		}
		
		/**
		 * 获得树干的渲染器 
		 * @param index
		 * @return 
		 * 
		 */
		public function getTrunkRenderAt(index:int):DisplayObject
		{
			var sp:Sprite = _renderContainer.getChildAt( index ) as Sprite;
			return sp.getChildAt( 0 );
		}
		
		/**
		 * 获得树叶节点的渲染器 
		 * @param trunkIndex
		 * @param nodeIndex
		 * @return 
		 * 
		 */
		public function getNodeRenderAt(trunkIndex:int,nodeIndex:int):DisplayObject
		{
			var sp:Sprite = _renderContainer.getChildAt( trunkIndex ) as Sprite;
			return sp.getChildAt( nodeIndex + 1 );
		}
		
		/**
		 * 获得树叶节点的数据 
		 * @param trunkIndex
		 * @param nodeIndex
		 * @return 
		 * 
		 */
		public function getNodeDatarAt(trunkIndex:int,nodeIndex:int):Object
		{
			var sp:Sprite = _renderContainer.getChildAt( trunkIndex ) as Sprite;
			return ITreeRender( sp.getChildAt( nodeIndex + 1) ).data;
		}
		
		
		/**
		 * 在指定位置添加一个子节点 
		 * @param data
		 * @param trunkIndex
		 * @param nodeIndex
		 * 
		 */
		public function addNoteAt(data:Object,trunkIndex:int,nodeIndex:int):void
		{
			if( trunkIndex < 0 ) return;
			if( trunkIndex >= _renderContainer.numChildren ) return;
			var sp:TreeSprite = _renderContainer.getChildAt( trunkIndex ) as TreeSprite;
			var render:DisplayObject = new _nodeRender();
			sp.addChildAt( render, nodeIndex + 1 );
			sp.update();
			ITreeRender( render ).tree = this;
			ITreeRender( render ).trunkIndex = trunkIndex;
			ITreeRender( render ).index = nodeIndex;
			ITreeRender( render ).data = data;
			updateOneTree( sp );
			UI.stage.invalidate();
			UI.stage.addEventListener( Event.RENDER, onStageRender );
		}
		
		/**
		 * 清除某个树干下面所有子节点 
		 * @param trunkIndex
		 * 
		 */
		public function clearTrunkAllChilds(trunkIndex:int):void
		{
			var sp:TreeSprite;
			sp = _renderContainer.getChildAt( trunkIndex ) as TreeSprite
			while( sp.numChildren > 1 ){
				if( _lastSelect == sp.getChildAt( 1 ) ){
					_lastSelect = null;
				}
				sp.removeChildAt( 1 );
			}
			updateOneTree( sp );
			sp.update();
			UI.stage.invalidate();
			UI.stage.addEventListener( Event.RENDER, onStageRender );
		}
		
		/**获取节点 索引
		 */		
		public function getNodeIndex(data:Object,trunkIndex:int):int
		{
			var sp:TreeSprite = _renderContainer.getChildAt( trunkIndex ) as TreeSprite;
			var len:int=sp.numChildren;
			var render:ITreeRender;
			for(var i:int=0;i!=len;++i)
			{
				render=ITreeRender(sp.getChildAt(i));
				if(render.data==data) return render.nodeIndex;
			}
			return -1;
		}
		/**删除节点
		 */		
		public function removeNode(data:Object,trunkIndex:int):Boolean
		{
			var nodeIndex:int=getNodeIndex(data,trunkIndex);
			if(nodeIndex!=-1)
			{
				return removeNoteAt(trunkIndex,nodeIndex);
			}
			return false;
		}
		/**删除所有的子节点
		 */		
		public function removeAllNode(trunkIndex:int):void
		{
			var sp:TreeSprite;
			sp = _renderContainer.getChildAt( trunkIndex ) as TreeSprite;
			var child:ITreeRender;
			while(sp.numChildren)
			{
				child=sp.removeChildAt(0) as ITreeRender;
				child.dispose();  // 释放内存
			}
			updateOneTree( sp );
			sp.update();
			UI.stage.addEventListener( Event.RENDER, onStageRender );
			UI.stage.invalidate();
		}
		public function removeNoteAt(trunkIndex:int,nodeIndex:int):Boolean
		{
			var sp:TreeSprite;
			sp = _renderContainer.getChildAt( trunkIndex ) as TreeSprite
			if( sp.numChildren <= nodeIndex +1 ) return false;
			if( _lastSelect == sp.getChildAt( nodeIndex + 1 )){
				_lastSelect = null;
			}
			var child:ITreeRender=sp.removeChildAt( nodeIndex + 1 ) as ITreeRender;
			child.dispose();  //释放 内存
			updateOneTree( sp );
			sp.update();
			UI.stage.invalidate();
			UI.stage.addEventListener( Event.RENDER, onStageRender );
			return true;
		}
		
		/**
		 * 查找某个数据的索引 
		 * @param data 要验证匹配的数据
		 * @param fieldName 如果要查找的数据是item对象的子属性，fieldName为不为空的属性名，如果为空，直接验证匹配item Object
		 * @return  查找到的位置，如果没有找到，返回-1
		 * 
		 */
		public function findTrunkDataIndex(data:*,fieldName:String=""):int
		{
			var len:int = _renderContainer.numChildren;
			for( var i:int=0; i<len; i++ ){
				var sp:Sprite = _renderContainer.getChildAt( i ) as Sprite;
				var trunk:ITreeRender;
				if( sp.numChildren > 0 ){
					trunk = sp.getChildAt( 0 ) as ITreeRender;
					if( trunk ){
						if( fieldName == "" ){
							if( trunk.data == data ){
								return i;
							}
						}else{
							if( trunk.data[ fieldName ] == data ){
								return i;
							}
						}
					}
				}
			}
			return -1;
		}
		
		/**
		 * 查找某个数据的索引 
		 * @param data 要验证匹配的数据
		 * @param fieldName 如果要查找的数据是item对象的子属性，fieldName为不为空的属性名，如果为空，直接验证匹配item Object
		 * @return  查找到的位置，如果没有找到，返回-1
		 * 
		 */
		public function findNodeDataTrunkIndex(data:*,fieldName:String=""):int
		{
			var len:int = _renderContainer.numChildren;
			for( var i:int=0; i<len; i++ ){
				var sp:Sprite = _renderContainer.getChildAt( i ) as Sprite;
				var node:ITreeRender;
				var nodeLen:int = sp.numChildren;
				for( var j:int=1; j<nodeLen; j++ ){
					node = sp.getChildAt( j ) as ITreeRender;
					if( node ){
						if( fieldName == "" ){
							if( node.data == data ){
								return i;
							}
						}else{
							if( node.data[ fieldName ] == data ){
								return i;
							}
						}
					}
				}
			}
			return -1;
		}
		
		/**
		 * 查找某个数据的索引 
		 * @param data 要验证匹配的数据
		 * @param fieldName 如果要查找的数据是item对象的子属性，fieldName为不为空的属性名，如果为空，直接验证匹配item Object
		 * @return  查找到的位置，如果没有找到，返回-1
		 * 
		 */
		public function findNodeDataNodeIndex(data:*,fieldName:String=""):int
		{
			var len:int = _renderContainer.numChildren;
			for( var i:int=0; i<len; i++ ){
				var sp:Sprite = _renderContainer.getChildAt( i ) as Sprite;
				var node:ITreeRender;
				var nodeLen:int = sp.numChildren;
				for( var j:int=1; j<nodeLen; j++ ){
					node = sp.getChildAt( j ) as ITreeRender;
					if( node ){
						if( fieldName == "" ){
							if( node.data == data ){
								return j;
							}
						}else{
							if( node.data[ fieldName ] == data ){
								return j;
							}
						}
					}
				}
			}
			return -1;
		}
		
		override public function targetSkin(skin:DisplayObject):void
		{
			_ui = skin as Sprite;
			_scrollBar = Xdis.getChild( _ui, "list_vScrollBar" );
			if( _scrollBar is VScrollBar == false ){
				AutoBuild.replaceAll( _ui );
				_scrollBar = Xdis.getChild( _ui, "list_vScrollBar" );
			}
			var hei:int = _scrollBar.height;
			_scrollBar.setSize( _scrollBar.compoWidth, hei * _ui.scaleY );
			_bg = Xdis.getChild( _ui, "bg" );
			resetXY( _ui );
			this.addChild( _scrollBar );
			this.addChildAt( _ui, 0 );
		}
		
		override public function setSize(newWidht:Number, newHeight:Number):void
		{
			super.setSize( newWidht, newHeight );
			var renderViewWidth:int = itemRenderViewWidth;
			_scrollBar.setTarget( _renderContainer, false, renderViewWidth, _compoHeight - scrollRectLess );
			_scrollBar.x = renderViewWidth;
			_scrollBar.setSize( _scrollBar.compoWidth, _compoHeight );
			if( _bg ){
				_bg.width = _compoWidth;
				_bg.height = _compoHeight;
			}
			resetItemSize ();
		}
		
		protected function get itemRenderViewWidth():int
		{
			return _compoWidth - _scrollBar.compoWidth + defaultScrollBarXAdd;
		}
		
		protected function resetItemSize():void
		{
			var renderViewWidth:int = itemRenderViewWidth;
			var num:int = _renderContainer.numChildren;
			var render:IListRender;
			var itemShowWidht:int = renderViewWidth;
			if( _scrollBar.visible == false ){
				itemShowWidht = _compoWidth;
			}
			for( var i:int=0; i<num; i++ ){
				render = IListRender( _renderContainer.getChildAt( i ) );
				render.setSize( itemShowWidht, render.height );
			}
		}
		
		/**
		 * 立即刷新Items的渲染和滚动条显示 
		 * 
		 */
		public function updateNow():void
		{
			onStageRender();
		}
		
		protected function onStageRender(event:Event=null):void
		{
			UI.stage.removeEventListener( Event.RENDER, onStageRender );
			var maxHeight:Number = Align.followVerticalOneByOne( _renderContainer );
			_scrollBar.updateSize( maxHeight );
		}
		
	}
}