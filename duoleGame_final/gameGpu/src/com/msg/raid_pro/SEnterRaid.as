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
	public dynamic final class SEnterRaid extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const ERROR_INFO:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.raid_pro.SEnterRaid.error_info", "errorInfo", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var errorInfo:int;

		/**
		 *  @private
		 */
		public static const ISEXITAPPEAR:FieldDescriptor$TYPE_BOOL = new FieldDescriptor$TYPE_BOOL("com.msg.raid_pro.SEnterRaid.isExitAppear", "isExitAppear", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var isExitAppear:Boolean;

		/**
		 *  @private
		 */
		public static const RAID_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.raid_pro.SEnterRaid.raid_id", "raidId", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		public var raidId:int;

		/**
		 *  @private
		 */
		public static const ENTER_TIMES:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.raid_pro.SEnterRaid.enter_times", "enterTimes", (4 << 3) | com.netease.protobuf.WireType.VARINT);

		public var enterTimes:int;

		/**
		 *  @private
		 */
		public static const REST_TIME:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.raid_pro.SEnterRaid.rest_time", "restTime", (5 << 3) | com.netease.protobuf.WireType.VARINT);

		public var restTime:int;

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.errorInfo);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_BOOL(output, this.isExitAppear);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.raidId);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 4);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.enterTimes);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 5);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.restTime);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var error_info$count:uint = 0;
			var isExitAppear$count:uint = 0;
			var raid_id$count:uint = 0;
			var enter_times$count:uint = 0;
			var rest_time$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (error_info$count != 0) {
						throw new flash.errors.IOError('Bad data format: SEnterRaid.errorInfo cannot be set twice.');
					}
					++error_info$count;
					this.errorInfo = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (isExitAppear$count != 0) {
						throw new flash.errors.IOError('Bad data format: SEnterRaid.isExitAppear cannot be set twice.');
					}
					++isExitAppear$count;
					this.isExitAppear = com.netease.protobuf.ReadUtils.read$TYPE_BOOL(input);
					break;
				case 3:
					if (raid_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: SEnterRaid.raidId cannot be set twice.');
					}
					++raid_id$count;
					this.raidId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 4:
					if (enter_times$count != 0) {
						throw new flash.errors.IOError('Bad data format: SEnterRaid.enterTimes cannot be set twice.');
					}
					++enter_times$count;
					this.enterTimes = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 5:
					if (rest_time$count != 0) {
						throw new flash.errors.IOError('Bad data format: SEnterRaid.restTime cannot be set twice.');
					}
					++rest_time$count;
					this.restTime = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
