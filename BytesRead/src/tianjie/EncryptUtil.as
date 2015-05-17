package tianjie
{
	import flash.utils.*;
	
	public class EncryptUtil {
		
		public static function encrypt(_arg1:ByteArray):ByteArray{
			var _local2:uint = ((_arg1.length / 2) >> 0);
			var _local3:ByteArray = new ByteArray();
			_arg1.position = 0;
			_local3.writeByte(_arg1.readUnsignedByte());
			_local3.writeByte(1);
			_local3.writeUnsignedInt(_local2);
			_local3.writeBytes(_arg1, _local2, (_arg1.length - _local2));
			_local3.writeBytes(_arg1, (0 + 3), (_local2 - 3));
			return (_local3);
		}
		public static function unencrypt(_arg1:ByteArray):ByteArray{
			_arg1.position = 0;
			var _local2:uint = _arg1.readUnsignedByte();
			var _local3:uint = _arg1.readUnsignedByte();
			if (_local3 != 1){
				return (_arg1);
			};
			var _local4:uint = _arg1.readUnsignedInt();
			var _local5:uint = _arg1.position;
			var _local6:ByteArray = new ByteArray();
			_local6.writeByte(_local2);
			_local6.writeByte(87);
			_local6.writeByte(83);
			_local6.writeBytes(_arg1, ((_arg1.length - _local4) + 3), (_local4 - 3));
			_local6.writeBytes(_arg1, _local5, (((_arg1.length - _local4) - _local5) + 3));
			_local6.position = 0;
			return (_local6);
		}
		
	}
}//package 