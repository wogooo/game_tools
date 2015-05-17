package com.YFFramework.game.core.module.login.view
{
	import com.YFFramework.core.event.ParamEvent;
	import com.YFFramework.core.ui.container.HContainer;
	import com.YFFramework.core.ui.layer.PopUpManager;
	import com.YFFramework.core.ui.yfComponent.controls.YFButton;
	import com.YFFramework.core.ui.yfComponent.controls.YFComboBox;
	import com.YFFramework.core.ui.yfComponent.controls.YFPane;
	import com.YFFramework.core.ui.yfComponent.controls.YFRadioButton;
	import com.YFFramework.core.ui.yfComponent.controls.YFTextInput;
	import com.YFFramework.core.ui.yfComponent.events.YFControlEvent;
	import com.YFFramework.core.world.model.type.TypeRole;
	import com.YFFramework.game.core.module.login.events.LoginEvent;
	import com.YFFramework.game.core.module.login.model.LoginVo;
	
	import flash.events.Event;
	import flash.events.MouseEvent;

	/** 登陆框
	 * 2012-8-2 下午12:49:00
	 *@author yefeng
	 */
	public class LoginView extends YFPane
	{
		
		
		/**职业
		 */
		private var _carrerContainer:HContainer;
		
		private var _sexBox:YFComboBox;
		/**确定按钮
		 */
		private var _button:YFButton;

		/**职业
		 */
		private var _career:String;
		/**名字输入文本
		 */		
		private var _nameTF:YFTextInput;
		public function LoginView()
		{
			super(400,300,false);
			PopUpManager.addPopUp(this)
			PopUpManager.centerPopUp(this);
			
			var radioButon:YFRadioButton=_carrerContainer.getChildAt(0) as YFRadioButton;
			radioButon.select=true;
		}
		override protected  function initUI():void
		{
			super.initUI();
			var radioButon:YFRadioButton;
			var careerArr:Array=["火云骑","雷法师","大力神"];//,"冰剑王"
			_carrerContainer=new HContainer(-50);
			addChild(_carrerContainer);
			for (var i:int=0;i!=careerArr.length;++i)
			{
				radioButon=new YFRadioButton(careerArr[i]);
				_carrerContainer.addChild(radioButon);
			}
			_carrerContainer.updateView();
			_carrerContainer.y=100;
			_carrerContainer.x=70
			_sexBox=new YFComboBox(50)
			_sexBox.addItem({name:"男",sex:TypeRole.Sex_Man},"name");
			_sexBox.addItem({name:"女",sex:TypeRole.Sex_Woman},"name");
			_sexBox.setSelectIndex(0);
			addChild(_sexBox);
			_sexBox.y=_carrerContainer.visualHeight+_carrerContainer.y+10;
			_sexBox.x=(width-_sexBox.width)*0.5;
			_nameTF=new YFTextInput("",2,12,0xFFFFFF,0x333333);
			_nameTF.y=_sexBox.y+_sexBox.visualHeight+10;
			_nameTF.x=(width-_nameTF.width)*0.5;
			
			addChild(_nameTF);
			
			_button=new YFButton("确定");
			addChild(_button);
			_button.y=_nameTF.y+_nameTF.visualHeight+10;
			_button.x=(width-_button.width)*0.5;
		}
		
		override protected  function  addEvents():void
		{
			super.addEvents();
			_button.addEventListener(MouseEvent.CLICK,onClick);	
			_carrerContainer.addEventListener(YFControlEvent.SelectChange,onChange);
		}
		override protected function removeEvents():void
		{
			super.removeEvents();
			_button.removeEventListener(MouseEvent.CLICK,onClick);	
			_carrerContainer.removeEventListener(YFControlEvent.SelectChange,onChange);

		}
		private function onClick(e:MouseEvent):void
		{
			var sex:int=_sexBox.getSelectData().sex;
			var myCareer:int;
		//	_career="冰剑王";
			switch(_career)
			{
				case "火云骑":
					myCareer=TypeRole.Career_1;
					break;
				case "雷法师":
					myCareer=TypeRole.Career_2;
					break;
				case "大力神":
					myCareer=TypeRole.Career_3;
					break;
				case "冰剑王":
					myCareer=TypeRole.Career_4;
					break;
			}
			
			var loginVo:LoginVo=new LoginVo();
			loginVo.sex=sex;
			loginVo.carrer=myCareer;
			loginVo.name=_nameTF.text;
			noticeLogin(loginVo);
		}
		private function onChange(e:ParamEvent):void
		{
			_career=(e.param  as YFRadioButton).text;
		}
		
		private function noticeLogin(vo:LoginVo):void
		{
//			var proto:Message=PoolCenter.Instance.getFromPool(Message) as Message;
//			proto.info=vo;
//			proto.cmd=CMDLogin.C_LOGIN;
			dispatchEvent(new ParamEvent(LoginEvent.C_Login,vo));
		}
		
		
		override public function dispose(e:Event=null):void
		{
			super.dispose();
			_carrerContainer=null;
			_sexBox=null;
	 		_button=null;
		}
	}
}