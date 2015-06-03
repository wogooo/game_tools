package com.YFFramework.game.core.module.GMtool.view
{
	import com.CMD.GameCmd;
	import com.YFFramework.core.map.rectMap.RectMapUtil;
	import com.YFFramework.core.map.rectMap.findPath.AStar;
	import com.YFFramework.core.net.loader.image_swf.UILoader;
	import com.YFFramework.game.gameConfig.URLTool;
	import com.dolo.ui.controls.Window;
	import com.dolo.ui.tools.Xdis;
	import com.msg.cheat.CCheatAddExperience;
	import com.msg.cheat.CCheatAddMoney;
	import com.msg.cheat.CCheatChangeLevel;
	import com.msg.cheat.CCheatFinishTask;
	import com.msg.cheat.CCheatGiveItem;
	import com.msg.cheat.CCheatUnDoTask;
	import com.msg.enumdef.MoneyType;
	import com.net.MsgPool;
	import com.netease.protobuf.Message;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.text.TextField;
	
	/***
	 *
	 *@author ludingchang 时间：2013-11-8 下午3:46:08
	 */
	public class GMToolWindow extends Window
	{
		/**as链接*/
		private static const UIName:String="GMToolUI";
		/**文件位置*/
		private static const URL_STR:String="GMUI.swf";
		private var _ui:Sprite;
		//道具
		private var _item_id:TextField;
		private var _item_num:TextField;
		private var _item_btn:SimpleButton;
		private var _item_type:TextField;
		//经验
		private var _exp:TextField;
		private var _exp_btn:SimpleButton;
		//游戏币
		private var _note:TextField;
		private var _note_btn:SimpleButton;
		//魔钻（人民币）
		private var _rmb:TextField;
		private var _rmb_btn:SimpleButton;
		//礼券
		private var _gift:TextField;
		private var _gift_btn:SimpleButton;
		//地图
		private var _map_id:TextField;
		private var _posX:TextField;
		private var _posY:TextField;
		private var _map_btn:SimpleButton;
		//背包
		private var _bag_btn:SimpleButton;
		//等级
		private var _level:TextField;
		private var _level_btn:SimpleButton;
		//任务
		private var _task:TextField;
		private var _task_finish_btn:SimpleButton;
		private var _task_undo_btn:SimpleButton;
		//阅历
		private var _see:TextField;
		private var _see_btn:SimpleButton;
		
		//寻路
		private var _fromX:TextField;
		private var _fromY:TextField;
		private var _endX:TextField;
		private var _endY:TextField;
		private var _astarBtn:SimpleButton;
		private var _outPut:TextField;
		
		private var _isLoad:Boolean;
		public function GMToolWindow()
		{
			_isLoad=false;
		}
		
		private function loadIt():void
		{
			if(!_isLoad)
			{
				var loader:UILoader=new UILoader;
				loader.loadCompleteCallback=init;
				loader.initData(URLTool.getDyModuleUI(URL_STR));
				_isLoad=true;
			}
		}
		private function init(content:DisplayObject,data:Object):void
		{
			_ui=initByArgument(650,500,UIName,null,false);
			_item_id=Xdis.getTextChild(_ui,"item_id");
			_item_num=Xdis.getTextChild(_ui,"item_num");
			_item_btn=Xdis.getSimpleButtonChild(_ui,"item_btn");
			_item_type=Xdis.getTextChild(_ui,"item_type");
			_exp=Xdis.getTextChild(_ui,"exp");
			_exp_btn=Xdis.getSimpleButtonChild(_ui,"exp_btn");
			_note=Xdis.getTextChild(_ui,"note");
			_note_btn=Xdis.getSimpleButtonChild(_ui,"note_btn");
			_rmb=Xdis.getTextChild(_ui,"rmb");
			_rmb_btn=Xdis.getSimpleButtonChild(_ui,"rmb_btn");
			_gift=Xdis.getTextChild(_ui,"gift");
			_gift_btn=Xdis.getSimpleButtonChild(_ui,"gift_btn");
			_map_id=Xdis.getTextChild(_ui,"map_id");
			_posX=Xdis.getTextChild(_ui,"pos_x");
			_posY=Xdis.getTextChild(_ui,"pos_y");
			_map_btn=Xdis.getSimpleButtonChild(_ui,"map_btn");
			_bag_btn=Xdis.getSimpleButtonChild(_ui,"bag_btn");
			_level=Xdis.getTextChild(_ui,"level");
			_level_btn=Xdis.getSimpleButtonChild(_ui,"level_btn");
			_task=Xdis.getTextChild(_ui,"task");
			_task_finish_btn=Xdis.getSimpleButtonChild(_ui,"task_finish_btn");
			_task_undo_btn=Xdis.getSimpleButtonChild(_ui,"task_undo_btn");
			_see=Xdis.getTextChild(_ui,"see");
			_see_btn=Xdis.getSimpleButtonChild(_ui,"see_btn");
			
			_item_btn.addEventListener(MouseEvent.CLICK,onClick);
			_exp_btn.addEventListener(MouseEvent.CLICK,onClick);
			_note_btn.addEventListener(MouseEvent.CLICK,onClick);
			_rmb_btn.addEventListener(MouseEvent.CLICK,onClick);
			_gift_btn.addEventListener(MouseEvent.CLICK,onClick);
			_map_btn.addEventListener(MouseEvent.CLICK,onClick);
			_bag_btn.addEventListener(MouseEvent.CLICK,onClick);
			_level_btn.addEventListener(MouseEvent.CLICK,onClick);
			_task_finish_btn.addEventListener(MouseEvent.CLICK,onClick);
			_task_undo_btn.addEventListener(MouseEvent.CLICK,onClick);
			_see_btn.addEventListener(MouseEvent.CLICK,onClick);
			
			
			_astarBtn=Xdis.getSimpleButtonChild(_ui,"astarBtn");
			_fromX=Xdis.getTextChild(_ui,"fromX");
			_fromY=Xdis.getTextChild(_ui,"fromY");
			_endX=Xdis.getTextChild(_ui,"endX");
			_endY=Xdis.getTextChild(_ui,"endY");
			_outPut=Xdis.getTextChild(_ui,"outPut");
			_outPut.mouseEnabled=true;
			_outPut.selectable=true;
			_astarBtn.addEventListener(MouseEvent.CLICK,onClick);
			
			////////////////////
			_map_btn.visible=false;
			_bag_btn.visible=false;
		}
		override public function open():void
		{
			super.open();
			loadIt();
			
		}
		
		protected function onClick(event:MouseEvent):void
		{
			switch(event.currentTarget)
			{
				case _item_btn:
					trace("item on click ...item_id:"+_item_id.text+"...item_num:"+_item_num.text+"...item_type:"+_item_type.text);
					var item_msg:CCheatGiveItem=new CCheatGiveItem;
					item_msg.itemId=int(_item_id.text);
					item_msg.itemType=int(_item_type.text);
					item_msg.itemNumber=int(_item_num.text);
					MsgPool.sendGameMsg(GameCmd.CCheatGiveItem,item_msg);
					break;
				case _exp_btn:
					var exp_msg:CCheatAddExperience=new CCheatAddExperience;
					exp_msg.exp=int(_exp.text);
					MsgPool.sendGameMsg(GameCmd.CCheatAddExperience,exp_msg);
					trace("exp on click ...exp:"+_exp.text);
					break;
				case _note_btn:
					var note_msg:CCheatAddMoney=new CCheatAddMoney;
					note_msg.moneyNumber=int(_note.text);
					note_msg.moneyType=MoneyType.MONEY_NOTE;
					MsgPool.sendGameMsg(GameCmd.CCheatAddMoney,note_msg);
					trace("note on click ...note:"+_note.text);
					break;
				case _rmb_btn:
					var rmb_msg:CCheatAddMoney=new CCheatAddMoney;
					rmb_msg.moneyNumber=int(_rmb.text);
					rmb_msg.moneyType=MoneyType.MONEY_DIAMOND;
					MsgPool.sendGameMsg(GameCmd.CCheatAddMoney,rmb_msg);
					trace("rmb on click ...rmb:"+_rmb.text);
					break;
				case _gift_btn:
					var gift_msg:CCheatAddMoney=new CCheatAddMoney;
					gift_msg.moneyNumber=int(_gift.text);
					gift_msg.moneyType=MoneyType.MONEY_COUPON;
					MsgPool.sendGameMsg(GameCmd.CCheatAddMoney,gift_msg);
					trace("gift on click ...gift:"+_gift.text);
					break;
				case _map_btn://////////////////////////
					trace("map on click ...map_id"+_map_id.text+"...posx:"+_posX.text+"...posy:"+_posY.text);
					break;
				case _bag_btn://///////////////////////////
					trace("bag on click");
					break;
				case _level_btn:
					var lv_msg:CCheatChangeLevel=new CCheatChangeLevel;
					lv_msg.newLevel=int(_level.text);
					MsgPool.sendGameMsg(GameCmd.CCheatChangeLevel,lv_msg);
					trace("level on click...level:"+_level.text);
					break;
				case _task_finish_btn:
					var task_finish_msg:CCheatFinishTask=new CCheatFinishTask;
					task_finish_msg.taskId=int(_task.text);
					MsgPool.sendGameMsg(GameCmd.CCheatFinishTask,task_finish_msg);
					trace("task finish on click...task_id:"+_task.text);
					break;
				case _task_undo_btn:
					var task_undo_msg:CCheatUnDoTask=new CCheatUnDoTask;
					task_undo_msg.taskId=int(_task.text);
					MsgPool.sendGameMsg(GameCmd.CCheatUnDoTask,task_undo_msg);
					trace("task undo on click...task_id:"+_task.text);
					break;
				case _astarBtn: //寻路配置
					var startX:int=int(_fromX.text)*30;
					var startY:int=int(_fromY.text)*30;
					var endX:int=int(_endX.text)*30;
					var endY:int=int(_endY.text)*30;
					var startTilePt:Point=RectMapUtil.getTilePosition(startX,startY);
					var endTilePt:Point=RectMapUtil.getTilePosition(endX,endY);
					if(AStar.Instance.seachPath(startTilePt,endTilePt))
					{
						var arr:Array=AStar.Instance.getPath();
						_outPut.text=convertPointArrToStr(new Point(startX,startY),arr);
					}
					else 
					{
						_outPut.text="";
					}
					break;
				case _see_btn:
					var see_msg:CCheatAddMoney=new CCheatAddMoney;
					see_msg.moneyNumber=int(_see.text);
					see_msg.moneyType=8;
					MsgPool.sendGameMsg(GameCmd.CCheatAddMoney,see_msg);
					trace("see on click ...see:"+_see.text);
					break;
			}
		}
		
		
		private function convertPointArrToStr(startPt:Point,arr:Array):String
		{
			var len:int=arr.length;
			var point:Point;
			var str:String="[";
			str +="["+startPt.x+","+startPt.y+"]" +",";
			for(var i:int=0;i!=len;++i)
			{
				point=arr[i];
				str +="["+point.x+","+point.y+"]" +","
			}
			str=str.substr(0,str.length-1);
			str=str+"]";
			return str;
		}
		
	}
}