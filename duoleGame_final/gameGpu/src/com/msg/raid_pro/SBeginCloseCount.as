package com.msg.raid_pro {
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
	public dynamic final class SBeginCloseCount extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const RAID_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.raid_pro.SBeginCloseCount.raid_id", "raidId", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var raidId:int;

		/**
		 *  @private
		 */
		public static const REST_SECONDS:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.raid_pro.SBeginCloseCount.rest_seconds", "restSeconds", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		private var rest_seconds$field:int;

		private var hasField$0:uint = 0;

		public function clearRestSeconds():void {
			hasField$0 &= 0xfffffffe;
			rest_seconds$field = new int();
		}

		public function get hasRestSeconds():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set restSeconds(value:int):void {
			hasField$0 |= 0x1;
			rest_seconds$field = value;
		}

		public function get restSeconds():int {
			return rest_seconds$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.raidId);
			if (hasRestSeconds) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, rest_seconds$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var raid_id$count:uint = 0;
			var rest_seconds$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (raid_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: SBeginCloseCount.raidId cannot be set twice.');
					}
					++raid_id$count;
					this.raidId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (rest_seconds$count != 0) {
						throw new flash.errors.IOError('Bad data format: SBeginCloseCount.restSeconds cannot be set twice.');
					}
					++rest_seconds$count;
					this.restSeconds = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
