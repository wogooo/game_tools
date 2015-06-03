package com.msg.pvp {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.msg.pvp.ResultNotice;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class SArenaResult extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const ACTIVITY_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.pvp.SArenaResult.activity_id", "activityId", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var activityId:int;

		/**
		 *  @private
		 */
		public static const RESULT_NOTICE:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.msg.pvp.SArenaResult.result_notice", "resultNotice", (2 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.msg.pvp.ResultNotice; });

		[ArrayElementType("com.msg.pvp.ResultNotice")]
		public var resultNotice:Array = [];

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.activityId);
			for (var resultNotice$index:uint = 0; resultNotice$index < this.resultNotice.length; ++resultNotice$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.resultNotice[resultNotice$index]);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var activity_id$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (activity_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: SArenaResult.activityId cannot be set twice.');
					}
					++activity_id$count;
					this.activityId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					this.resultNotice.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.msg.pvp.ResultNotice()));
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
