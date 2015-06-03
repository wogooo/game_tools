package com.msg.task {
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
	public dynamic final class RunTaskInf extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const RUN_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.task.RunTaskInf.run_id", "runId", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var runId:int;

		/**
		 *  @private
		 */
		public static const REMAIN_TIMES:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.task.RunTaskInf.remain_times", "remainTimes", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var remainTimes:int;

		/**
		 *  @private
		 */
		public static const CUR_PROGRESS:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.task.RunTaskInf.cur_progress", "curProgress", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		public var curProgress:int;

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.runId);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.remainTimes);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.curProgress);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var run_id$count:uint = 0;
			var remain_times$count:uint = 0;
			var cur_progress$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (run_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: RunTaskInf.runId cannot be set twice.');
					}
					++run_id$count;
					this.runId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (remain_times$count != 0) {
						throw new flash.errors.IOError('Bad data format: RunTaskInf.remainTimes cannot be set twice.');
					}
					++remain_times$count;
					this.remainTimes = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					if (cur_progress$count != 0) {
						throw new flash.errors.IOError('Bad data format: RunTaskInf.curProgress cannot be set twice.');
					}
					++cur_progress$count;
					this.curProgress = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
