package manager
{
	import com.YFFramework.core.utils.common.ClassInstance;
	
	import flash.system.ApplicationDomain;

	public class SWFData
	{
		public var clasName:String;
		public var domain:ApplicationDomain;
		public function SWFData()
		{
		}
		public function getData():*
		{
			return ClassInstance.getInstance2(clasName,domain);
		}
	}
}