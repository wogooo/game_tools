package com.msg.item {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class CGetCharEquipListReq extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const APPEND:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.item.CGetCharEquipListReq.append", "append", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		private var append$field:int;

		private var hasField$0:uint = 0;

		public function clearAppend():void {
			hasField$0 &= 0xfffffffe;
			append$field = new int();
		}

		public function get hasAppend():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set append(value:int):void {
			hasField$0 |= 0x1;
			append$field = value;
		}

		public function get append():int {
			return append$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			if (hasAppend) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, append$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var append$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (append$count != 0) {
						throw new flash.errors.IOError('Bad data format: CGetCharEquipListReq.append cannot be set twice.');
					}
					++append$count;
					this.append = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
