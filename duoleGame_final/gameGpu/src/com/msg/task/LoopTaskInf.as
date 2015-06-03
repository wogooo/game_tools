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
	public dynamic final class LoopTaskInf extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const LOOP_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.task.LoopTaskInf.loop_id", "loopId", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var loopId:int;

		/**
		 *  @private
		 */
		public static const CUR_PROGRESS:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.task.LoopTaskInf.cur_progress", "curProgress", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var curProgress:int;

		/**
		 *  @private
		 */
		public static const REMAIN_TIMES:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.task.LoopTaskInf.remain_times", "remainTimes", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		public var remainTimes:int;

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.loopId);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.curProgress);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.remainTimes);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var loop_id$count:uint = 0;
			var cur_progress$count:uint = 0;
			var remain_times$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (loop_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: LoopTaskInf.loopId cannot be set twice.');
					}
					++loop_id$count;
					this.loopId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (cur_progress$count != 0) {
						throw new flash.errors.IOError('Bad data format: LoopTaskInf.curProgress cannot be set twice.');
					}
					++cur_progress$count;
					this.curProgress = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					if (remain_times$count != 0) {
						throw new flash.errors.IOError('Bad data format: LoopTaskInf.remainTimes cannot be set twice.');
					}
					++remain_times$count;
					this.remainTimes = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
