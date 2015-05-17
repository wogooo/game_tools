package view
{
	import com.YFFramework.air.flex.DragUI;
	
	import mx.events.FlexEvent;
	
	import spark.components.Label;
	import spark.components.TextInput;

	/**怪物区域
	 * 2012-11-8 上午11:09:46
	 *@author yefeng
	 */
	public class MonsterZoneClip extends DragUI
	{
		
		
		public var myId:int; ///怪物位置id 
		private var _monsterZone:MonsterZone;
		
		public var label:TextInput;
		
		public function MonsterZoneClip()
		{
			super();
			_monsterZone=new MonsterZone();
			addElement(_monsterZone);
			_monsterZone.mouseChildren=_monsterZone.mouseEnabled=false
			_monsterZone.width=13;
			_monsterZone.height=13;
			_monsterZone.x=-_monsterZone.width*0.5;
			_monsterZone.y=-_monsterZone.height*0.5;
			label=new TextInput();
			addElement(label)
			label.width=50
			label.height=20;
			label.x=-label.width*0.5;
			label.y=-_monsterZone.height-label.height;
		}
		
		override public function dispose(e:FlexEvent=null):void
		{
			super.dispose();
			_monsterZone=null;
			label=null;
		}
		/**携带的数据  {name,x,y} 
		 */ 
		public function  get  data():Object
		{
			return {name:label.text,x:x,y:y,id:myId}
		}
		
	}
}