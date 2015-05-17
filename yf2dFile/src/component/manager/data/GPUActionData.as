package component.manager.data
{
	import flash.display.BitmapData;
	import flash.utils.Dictionary;

	/**@author yefeng
	 *20122012-4-16下午11:28:56
	 */
	public class GPUActionData
	{
		public var dataType:int;
		public var bitmapDataArr:Vector.<BitmapData>;
		
		public  var headerData:Object;
		public var dataDict:Object; ///保存的是frameDatas
		public function GPUActionData()
		{
			headerData={};
			dataDict=new Object();
			dataType=TypeActionData.All;
			bitmapDataArr=new Vector.<BitmapData>(); 
				

		}
	}
}