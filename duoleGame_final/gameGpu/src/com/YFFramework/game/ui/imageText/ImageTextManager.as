package com.YFFramework.game.ui.imageText
{
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.utils.common.ClassInstance;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	/**  文本数字 以及其他的攻击文字   皮肤取自 FightUI.swf
	 * 2012-7-23 下午12:31:32
	 *@author yefeng
	 */
	public class ImageTextManager
	{
		
		/// 七种字体颜色
		/** 数字
		 */		
		private static const Num:String="Num";
		/** 文本
		 */		
		private static const Text:String="Text";
		private var _dict:Dictionary;
		
		private static var _pool:Vector.<AbsView>;
		
		
		
		
		private static var _instance:ImageTextManager;
		public function ImageTextManager()
		{
			_dict=new Dictionary();		
			_dict[Num]=new Dictionary();
			_dict[Text]=new Dictionary();
			_pool=new Vector.<AbsView>();
			initAllSkin();
			
		}
		
		public static function get Instance():ImageTextManager
		{
			if(!_instance) _instance=new ImageTextManager();
			return _instance;
		}
		/**初始化所有的 皮肤
		 */
		private  function initAllSkin():void
		{
			/********************数字文字**********************/
			
			// 怪物受伤 弹血数据
			var monsterHurtData:BitmapData=ClassInstance.getInstance("fightText_monsterNum") as BitmapData;//
			//怪物减号
			var monsterMinusData:BitmapData=ClassInstance.getInstance("fightText_monsterMinus");
			//加魔 数据
			var addMpNumData:BitmapData=ClassInstance.getInstance("fightText_addMpNum") as BitmapData; ///1
			//加魔法加号
			var addMpPlusData:BitmapData=ClassInstance.getInstance("fightText_addMpPlus") as BitmapData; 
			//扣蓝减号
			var minusMpData:BitmapData=ClassInstance.getInstance("fightText_addMpMinus") as BitmapData; 
			//加血数字  吃药 加血
			var addHpNumData:BitmapData=ClassInstance.getInstance("fightText_addHpNum") as BitmapData;///
			//人物加血的加号
			var addHpPlusData:BitmapData=ClassInstance.getInstance("fightText_addHpPlus") as BitmapData;
			//人物扣血数据
			var minusHpNumData:BitmapData=ClassInstance.getInstance("fightText_minusHpNum") as BitmapData;//
			//人物扣血减号
			var roleHpMinusData:BitmapData=ClassInstance.getInstance("fightText_roleHpMinus") as BitmapData;//

			var yellow_3_data:BitmapData=ClassInstance.getInstance("numPlayer1") as BitmapData;//arpg测试用数字
			//战斗力加号
			var powerPulsData:BitmapData=ClassInstance.getInstance("fightText_power_plus") as BitmapData;
			//战斗力减号
			var powerMinusData:BitmapData=ClassInstance.getInstance("fightText_power_minus") as BitmapData;
			//战斗力红色小数字（减少）
			var powerRedNumData:BitmapData=ClassInstance.getInstance("fightText_power_num1") as BitmapData;
			//战斗力绿色小数字（增加）
			var powerGreenNumData:BitmapData=ClassInstance.getInstance("fightText_power_num2") as BitmapData;
			//战斗力大数字
			var powerBigNumData:BitmapData=ClassInstance.getInstance("fightText_power_BigNum") as BitmapData;
			//角色面板上的战斗小数字
			var powerNum:BitmapData=ClassInstance.getInstance("numPlayer2") as BitmapData;
			
//			var yellow_4_data:BitmapData=ClassInstance.getInstance("img202") as BitmapData;
//			var blueData:BitmapData=ClassInstance.getInstance("img105") as BitmapData;//	
			
			///创建
			_dict[Num][TypeImageText.Num_MonsterHurt]=createData(monsterHurtData,10);
			// 怪物减号
			_dict[Text][TypeImageText.Num_MonsterMinus]=monsterMinusData;
			//加魔 数字 
			_dict[Num][TypeImageText.Num_Add_MP]=createData(addMpNumData);
			//加魔的加号
			_dict[Text][TypeImageText.Num_Add_MP_plus]=addMpPlusData;
			//扣蓝减号
			_dict[Text][TypeImageText.Num_Add_MP_Minus]=minusMpData;
			
			_dict[Num][TypeImageText.Num_Add_Hp]=createData(addHpNumData);
			_dict[Text][TypeImageText.Num_Add_Hp_Plus]=addHpPlusData;
			_dict[Num][TypeImageText.Num_RoleHurt]=createData(minusHpNumData);	
			_dict[Text][TypeImageText.Num_RoleHurt_Minus]=roleHpMinusData;
			_dict[Num][TypeImageText.ACTIVITY_NUM_BIG]=createData(yellow_3_data,10);
//			_dict[Num][TypeImageText.Num_Yellow_4]=createData(yellow_4_data);
//			_dict[Num][TypeImageText.Num_Blue]=createData(blueData);
			/***************************战斗力数字相关**************************/
			
			_dict[Num][TypeImageText.Num_power]=createData(powerNum,10);
			_dict[Text][TypeImageText.Power_Minus]=powerMinusData;
			_dict[Text][TypeImageText.Power_Plus]=powerPulsData;
			_dict[Num][TypeImageText.Power_Big_Num]=createData(powerBigNumData);
			_dict[Num][TypeImageText.Power_Red_Num]=createData(powerRedNumData);
			_dict[Num][TypeImageText.Power_Green_Num]=createData(powerGreenNumData);
				
			/****************************文本文字*****************************/
			
			/////经验 
			var expData:BitmapData=ClassInstance.getInstance("exp") as BitmapData;
			///攻击
//			var atkData_add:BitmapData=ClassInstance.getInstance("attackadd") as BitmapData;	
//			var atkData_mul:BitmapData=ClassInstance.getInstance("attackmul") as BitmapData;	

			///防御 
//			var defenseData_add:BitmapData=ClassInstance.getInstance("defenceadd") as BitmapData; 
//			var defenseData_mul:BitmapData=ClassInstance.getInstance("defencemul") as BitmapData; 
			///生命值
//			var hpData_add:BitmapData=ClassInstance.getInstance("max_hpadd") as BitmapData;
//			var hpData_mul:BitmapData=ClassInstance.getInstance("max_hpmul") as BitmapData;
			
			//暴击 
			var monsterCrit:BitmapData=ClassInstance.getInstance("fightText_monsterCrit") as BitmapData
			/// Miss fightUI_shanbi
			var monsterMissData:BitmapData=ClassInstance.getInstance("fightText_monsterMISS") as BitmapData;
			//（显示在舞台中下的）战斗力文字
			var powerData:BitmapData=ClassInstance.getInstance("fightText_power") as BitmapData;
			///创建
			
			// miss
			_dict[Text][TypeImageText.Monster_Miss]=monsterMissData;
			//暴击
			_dict[Text][TypeImageText.Monster_Crit]=monsterCrit;
			
			
			
			var roleCrit:BitmapData=ClassInstance.getInstance("fightText_role_crit") as BitmapData
			/// Miss fightUI_shanbi
			var roleMissData:BitmapData=ClassInstance.getInstance("fightText_role_miss") as BitmapData;
			///创建
			
			// miss
			_dict[Text][TypeImageText.Role_Miss]=roleMissData;
			//暴击
			_dict[Text][TypeImageText.Role_Crit]=roleCrit;
			
			///经验
			_dict[Text][TypeImageText.Text_Exp]=expData;
			//战斗力文字
			_dict[Text][TypeImageText.Text_Power]=powerData;
			/// 攻击
//			_dict[Text][TypeImageText.Text_Atk_Add]=atkData_add;
//			_dict[Text][TypeImageText.Text_Atk_Mul]=atkData_mul;
			
			
			/// 防御
//			_dict[Text][TypeImageText.Text_Defense_Add]=defenseData_add;
//			_dict[Text][TypeImageText.Text_Defense_Mul]=defenseData_mul;
			/// 生命值
//			_dict[Text][TypeImageText.Text_Hp_Add]=hpData_add;
//			_dict[Text][TypeImageText.Text_Hp_Mul]=hpData_mul;
		}
		public function getNumArr(numType:int):Vector.<BitmapData>
		{
			return _dict[Num][numType];
		}
		

		
		/**
		 * @param sourceData 整个 bitmapData  将其切割成len个bitmapData
		 */
		private  function createData(sourceData:BitmapData,len:int=10):Vector.<BitmapData>
		{
//			var len:int=11;
			var cellData:BitmapData;
			var cellW:int=int(sourceData.width/len);
			var cellH:int=sourceData.height;
			var matrix:Matrix=new Matrix();
			var pt:Point=new Point();
			var rect:Rectangle=new Rectangle(0,0,cellW,cellH);
			var arr:Vector.<BitmapData>=new Vector.<BitmapData>();
			for(var i:int=0;i!=len;++i)
			{
				rect.x=i*cellW;
				matrix.tx=-i*cellW;
				cellData=new BitmapData(cellW,cellH,true);
				cellData.copyPixels(sourceData,rect,pt);
				arr[i]=cellData;
			}
			///释放大图内存 
			sourceData.dispose();
			return arr;
		}
		
		
		/** 获取文字皮肤   id 是 Green Red 这样的数值  index 是在数组中的位置  默认   0  代表  -/+     1-10  代表数值   比如取数字 5  则是   5+1
		 */
		private  function getNumSkin(id:int,index:int):BitmapData
		{
			return _dict[Num][id][index];
		}
		
		
		
		
		
		/**创建文字数字   num为数字  不包含前缀符号 "+/-"  要想包含请使用下面的方法createNumWidthPre
		 */
		public   function createNum(num:String,id:int=1):AbsView
		{
			var str:String=num;
			var arr:Array=str.split("");
			var myNum:int;
			var sp:AbsView= new AbsView();
			var data:BitmapData;
			var lastX:int=0;
			var bmp:Bitmap;
			for each (str in arr)
			{
				myNum=int(str);
				data=getNumSkin(id,myNum);
				bmp=new Bitmap(data);
				bmp.x=lastX;
				sp.addChild(bmp);
				lastX +=data.width;
			}
			return sp;
		}
		
		/**
		 * 创建带有符号的数字
		 * @param num 正负数字均可
		 * @param numSkinType 数字选用的皮肤图片
		 * @param minus 减号皮肤图片
		 * @param plus 加号皮肤图片
		 * @return 
		 * 
		 */		
		public  function createNumWithPre(num:int,numSkinType:int,minus:int=0,plus:int=0):AbsView
		{
			var numStr:String=num.toString();
			var numStrAry:Array=numStr.split("");
			
			var sp:AbsView=new AbsView();
			var data:BitmapData;
			var lastX:int=0;
			var symbol:Bitmap;//加减号
			if(num < 0)
			{
				data=_dict[Text][minus];
				numStrAry.shift();
			}
			else 
				data=_dict[Text][plus];
			symbol=new Bitmap(data);
			sp.addChild(symbol);
			lastX +=data.width;
			var myNum:int;
			for each (numStr in numStrAry)
			{
				myNum=int(numStr);
				data=getNumSkin(numSkinType,myNum);
				symbol=new Bitmap(data);
				symbol.x=lastX;
				sp.addChild(symbol);
				lastX +=data.width;
			}
			return sp;
		}
		/**创建加血文字
		 */		
//		public function getAddBloodText(num:String):AbsView
//		{
//			return createNumWidthPre(num,TypeImageText.Num_Add_MP);
//		}
		
		
		/**创建文本
		 */ 
		public function createText(textId:int):AbsView
		{
			var bitmapData:BitmapData=_dict[Text][textId] ;
			var ui:AbsView=new AbsView();
			ui.addChild(new Bitmap(bitmapData));
			return ui;
		}
		
		/** 创建文字   包含文本和数字
		 *   比如 经验+5     textId 就是  经验      num 是 5   skinId 是num的样式  文字默认有 +号 
		 * numType 值为 0 表示没有 + - 号  为  1 表示 +  为2  表示-
		 */		
		public function createTextNum(textId:int,num:String,numSkinId:int):AbsView
		{
			var sp:AbsView=new AbsView();
			var lastX:int=0;
			var textData:BitmapData=_dict[Text][textId] ;
			var textBmp:Bitmap=new Bitmap(textData);
			sp.addChild(textBmp);
			lastX +=textData.width;
			var str:String=num;
			var arr:Array=str.split("");
			var myNum:int;
			var data:BitmapData;
			var bmp:Bitmap;
			//创建前缀符号
			data=getNumSkin(numSkinId,0);
			bmp=new Bitmap(data);
			sp.addChild(bmp);
			bmp.x=lastX;
			lastX +=data.width;
			for each (str in arr)
			{
				myNum=int(str);
				data=getNumSkin(numSkinId,myNum+1);
				bmp=new Bitmap(data);
				bmp.x=lastX;
				sp.addChild(bmp);
				lastX +=data.width;
			}
			return sp;

		}
		
			/// --------------------新 ------------------------------------------------------------
			
		/**创建怪物受血伤害 数字   -123
		 */		
		public function  createMonsterBlood(num:String):AbsView
		{
			var str:String=num;
			var arr:Array=str.split("");
			var myNum:int;
			var sp:AbsView= new AbsView();
			var data:BitmapData;
			var lastX:int=0;
			var bmp:Bitmap;
			var minusData:BitmapData=_dict[Text][TypeImageText.Num_MonsterMinus];
			bmp=new Bitmap(minusData);
			bmp.x=lastX;
			sp.addChild(bmp);
			lastX +=minusData.width;
			for each (str in arr)
			{
				myNum=int(str);
				data=_dict[Num][TypeImageText.Num_MonsterHurt][myNum];
				bmp=new Bitmap(data);
				bmp.x=lastX;
				sp.addChild(bmp);
				lastX +=data.width;
			}
			return sp;

		}
		/**创建角色受血伤害  数字   -123
		 */		
		public function createRoleBlood(num:String):AbsView
		{
			var str:String=num;
			var arr:Array=str.split("");
			var myNum:int;
			var sp:AbsView= new AbsView();
			var data:BitmapData;
			var lastX:int=0;
			var bmp:Bitmap;
			var minusData:BitmapData=_dict[Text][TypeImageText.Num_RoleHurt_Minus];
			bmp=new Bitmap(minusData);
			bmp.x=lastX;
			sp.addChild(bmp);
			lastX +=minusData.width;
			for each (str in arr)
			{
				myNum=int(str);
				data=_dict[Num][TypeImageText.Num_RoleHurt][myNum];
				bmp=new Bitmap(data);
				bmp.x=lastX;
				sp.addChild(bmp);
				lastX +=data.width;
			}
			return sp;
		}
		
		/**加蓝 字体   +123
		 */		
		public function createAddMp(num:String):AbsView
		{
			var str:String=num;
			var arr:Array=str.split("");
			var myNum:int;
			var sp:AbsView= new AbsView();
			var data:BitmapData;
			var lastX:int=0;
			var bmp:Bitmap;
			var plusData:BitmapData=_dict[Text][TypeImageText.Num_Add_MP_plus];
			bmp=new Bitmap(plusData);
			bmp.x=lastX;
			sp.addChild(bmp);
			lastX +=plusData.width;
			for each (str in arr)
			{
				myNum=int(str);
				data=_dict[Num][TypeImageText.Num_Add_MP][myNum];
				bmp=new Bitmap(data);
				bmp.x=lastX;
				sp.addChild(bmp);
				lastX +=data.width;
			}
			return sp;
		}
		/**扣蓝 掉蓝
		 */		
		public function createMinusMp(num:String):AbsView
		{
			var str:String=num;
			var arr:Array=str.split("");
			var myNum:int;
			var sp:AbsView= new AbsView();
			var data:BitmapData;
			var lastX:int=0;
			var bmp:Bitmap;
			var plusData:BitmapData=_dict[Text][TypeImageText.Num_Add_MP_Minus];
			bmp=new Bitmap(plusData);
			bmp.x=lastX;
			sp.addChild(bmp);
			lastX +=plusData.width;
			for each (str in arr)
			{
				myNum=int(str);
				data=_dict[Num][TypeImageText.Num_Add_MP][myNum];
				bmp=new Bitmap(data);
				bmp.x=lastX;
				sp.addChild(bmp);
				lastX +=data.width;
			}
			return sp;
		}
		
		
		/**加血 字体   +123
		 */		
		public function createAddHp(num:String):AbsView
		{
			var str:String=num;
			var arr:Array=str.split("");
			var myNum:int;
			var sp:AbsView= new AbsView();
			var data:BitmapData;
			var lastX:int=0;
			var bmp:Bitmap;
			var plusData:BitmapData=_dict[Text][TypeImageText.Num_Add_Hp_Plus];
			bmp=new Bitmap(plusData);
			bmp.x=lastX;
			sp.addChild(bmp);
			lastX +=plusData.width;
			for each (str in arr)
			{
				myNum=int(str);
				data=_dict[Num][TypeImageText.Num_Add_Hp][myNum];
				bmp=new Bitmap(data);
				bmp.x=lastX;
				sp.addChild(bmp);
				lastX +=data.width;
			}
			return sp;
		}
		
		
		/** 创建怪物暴击
		 */		
		public function createMonsterCrit():Bitmap
		{
			var bitmap:Bitmap=new Bitmap();
			var bitmapData:BitmapData=_dict[Text][TypeImageText.Monster_Crit];
			bitmap.bitmapData=bitmapData;
			return bitmap;
		}
		/** 创建怪物miss
		 */		
		public function createMonsterMiss():Bitmap
		{
			var bitmap:Bitmap=new Bitmap();
			var bitmapData:BitmapData=_dict[Text][TypeImageText.Monster_Miss];
			bitmap.bitmapData=bitmapData;
			return bitmap;
		}
		/**创建玩家暴击
		 */		
		public function createRoleCrit():Bitmap
		{
			var bitmap:Bitmap=new Bitmap();
			var bitmapData:BitmapData=_dict[Text][TypeImageText.Role_Crit];
			bitmap.bitmapData=bitmapData;
			return bitmap;
		}
		/** 创建玩家miss
		 */		
		public function createRoleMiss():Bitmap
		{
			var bitmap:Bitmap=new Bitmap();
			var bitmapData:BitmapData=_dict[Text][TypeImageText.Role_Miss];
			bitmap.bitmapData=bitmapData;
			return bitmap;
		}
		
		/** 创建舞台上的战斗力文字 */		
		public function createPowerTxt():Bitmap
		{
			var bitmap:Bitmap=new Bitmap();
			var bitmapData:BitmapData=_dict[Text][TypeImageText.Text_Power];
			bitmap.bitmapData=bitmapData;
			return bitmap;
		}
		
	}
}