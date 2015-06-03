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
	public dynamic final class SObtainRaid extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const RAID_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.raid_pro.SObtainRaid.raid_id", "raidId", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var raidId:int;

		/**
		 *  @private
		 */
		public static const CLOSE_TIME:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.raid_pro.SObtainRaid.close_time", "closeTime", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		private var close_time$field:int;

		private var hasField$0:uint = 0;

		public function clearCloseTime():void {
			hasField$0 &= 0xfffffffe;
			close_time$field = new int();
		}

		public function get hasCloseTime():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set closeTime(value:int):void {
			hasField$0 |= 0x1;
			close_time$field = value;
		}

		public function get closeTime():int {
			return close_time$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.raidId);
			if (hasCloseTime) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, close_time$field);
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
			var close_time$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (raid_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: SObtainRaid.raidId cannot be set twice.');
					}
					++raid_id$count;
					this.raidId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (close_time$count != 0) {
						throw new flash.errors.IOError('Bad data format: SObtainRaid.closeTime cannot be set twice.');
					}
					++close_time$count;
					this.closeTime = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
