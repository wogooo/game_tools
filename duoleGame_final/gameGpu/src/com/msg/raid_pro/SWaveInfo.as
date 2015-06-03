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
	public dynamic final class SWaveInfo extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const CURRENT_WAVE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.raid_pro.SWaveInfo.current_wave", "currentWave", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var currentWave:int;

		/**
		 *  @private
		 */
		public static const WAIT_TIME:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.raid_pro.SWaveInfo.wait_time", "waitTime", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		private var wait_time$field:int;

		private var hasField$0:uint = 0;

		public function clearWaitTime():void {
			hasField$0 &= 0xfffffffe;
			wait_time$field = new int();
		}

		public function get hasWaitTime():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set waitTime(value:int):void {
			hasField$0 |= 0x1;
			wait_time$field = value;
		}

		public function get waitTime():int {
			return wait_time$field;
		}

		/**
		 *  @private
		 */
		public static const TOTAL_WAVE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.raid_pro.SWaveInfo.total_wave", "totalWave", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		public var totalWave:int;

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.currentWave);
			if (hasWaitTime) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, wait_time$field);
			}
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.totalWave);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var current_wave$count:uint = 0;
			var wait_time$count:uint = 0;
			var total_wave$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (current_wave$count != 0) {
						throw new flash.errors.IOError('Bad data format: SWaveInfo.currentWave cannot be set twice.');
					}
					++current_wave$count;
					this.currentWave = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (wait_time$count != 0) {
						throw new flash.errors.IOError('Bad data format: SWaveInfo.waitTime cannot be set twice.');
					}
					++wait_time$count;
					this.waitTime = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					if (total_wave$count != 0) {
						throw new flash.errors.IOError('Bad data format: SWaveInfo.totalWave cannot be set twice.');
					}
					++total_wave$count;
					this.totalWave = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
