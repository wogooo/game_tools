package gpu2d.core
{
	import flash.display3D.Context3D;
	import flash.display3D.Program3D;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import gpu2d.errors.SingletonError;

	/**
	 * author :夜枫
	 * 时间 ：2011-11-21 下午01:03:02
	 */
	public final class GProgramManager
	{
		private  var mPrograms:Dictionary;
		private static  var _instance:GProgramManager;
		public function GProgramManager()
		{
			if(_instance) throw new SingletonError();
			else init();
		}
		public static function get Instance():GProgramManager
		{
			if(!_instance) _instance=new GProgramManager();
			return _instance;
		}
		
		private function init():void
		{
			mPrograms=new Dictionary();
		}
		
		// program management
		
		public function regProgram(name:String, vertexProgram:ByteArray, fragmentProgram:ByteArray):void
		{
			if (mPrograms.hasOwnProperty(name))
				throw new Error("Another program with this name is already registered");
			
			var context3d:Context3D=Gpu2d.Instance.context3d;
			var program:Program3D = context3d.createProgram();
			program.upload(vertexProgram, fragmentProgram);            
			mPrograms[name] = program;
		}
		
		public function delProgram(name:String):void
		{
			var program:Program3D = getProgram(name);            
			if (program)
			{                
				program.dispose();
				program=null;
				delete mPrograms[name];
			}
		}
		
		public function getProgram(name:String):Program3D
		{
			return mPrograms[name] as Program3D;
		}
	}
}