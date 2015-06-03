package com.YFFramework.game.core.global.util
{
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	/**字节操作工具
	 * @author yefeng
	 * 2013 2013-4-13 下午1:27:26 
	 */
	public class BytesUtil
	{
		private static 	var bytes:ByteArray=new ByteArray();
		private static var testPoint:Point=new Point();
		
		public function BytesUtil()
		{
		}
		/**  一个 int32 转化为  2个short用来保存坐标点
		 * {x:x,y:y}
		 */		
		public static function int32ToShortPoint(int32Value:int):Point
		{
			bytes.clear();
			bytes.writeUnsignedInt(int32Value);
			bytes.position=0;
			testPoint.x=bytes.readShort();
			testPoint.y=bytes.readShort();
			return testPoint;
		}
		/**   两个  short 型转化为一个int型 
		 * @param x       x   x坐标 不能超过 32768   2  的  15次方
		 * @param y		y    y坐标 不能超过 32768 2  的  15次方
		 * @return 
		 */
		public static function ShortPointToInt32(x:int,y:int):int
		{
			bytes.clear();
			bytes.writeShort(x);
			bytes.writeShort(y);
			bytes.position=0;
			var int32Value:int=bytes.readUnsignedInt();
			return int32Value;
		}
		/**获取vo 对应的Object
		 */		
		public static function getObject(vo:*):Object
		{
			var bytes:ByteArray=new ByteArray();
			bytes.writeObject(vo);
			bytes.position=0;
			return bytes.readObject();
		}
			
			
		
	}
}