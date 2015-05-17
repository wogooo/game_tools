package component
{
	/**
	 *  @author yefeng
	 *   @time:2012-4-7下午04:23:20
	 */
	import com.YFFramework.air.flex.DragUI;
	
	import mx.events.FlexEvent;
	
	import spark.components.TextInput;
	
	
	public class ProgressUI extends DragUI
	{
	
		private var progressBar:ProgressBar;
		private var header:TextInput;
		public function ProgressUI(autoRemove:Boolean=false)
		{
			super(autoRemove);
			progressBar=new ProgressBar();
			addElement(progressBar);
			header=new TextInput();
			addElement(header);
			
			header.height=20;
			header.width=40;
			header.y=-progressBar.height-header.height-5;
			header.x=progressBar.width*0.5+20
			header.mouseChildren=header.mouseEnabled=false;
		
		}
		public function gotoAndStop(value:int):void
		{
			Object(progressBar).gotoAndStop(value);
			header.text=value+"%"
		}
		
		public function reset():void
		{
			gotoAndStop(1);
		}
		
		
		
		override public function dispose(e:FlexEvent=null):void
		{
			// TODO Auto Generated method stub
			super.dispose(e);
			removeAllElements();
			progressBar=null;
		}
		  
	}
} 