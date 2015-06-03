package com.msg.task {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.msg.task.TaskInf;
	import com.msg.enumdef.RspMsg;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class SAcceptTaskRsp extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const TASK_INF:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.msg.task.SAcceptTaskRsp.task_inf", "taskInf", (1 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.msg.task.TaskInf; });

		public var taskInf:com.msg.task.TaskInf;

		/**
		 *  @private
		 */
		public static const RSP:FieldDescriptor$TYPE_ENUM = new FieldDescriptor$TYPE_ENUM("com.msg.task.SAcceptTaskRsp.rsp", "rsp", (2 << 3) | com.netease.protobuf.WireType.VARINT, com.msg.enumdef.RspMsg);

		public var rsp:int;

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.taskInf);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_ENUM(output, this.rsp);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var task_inf$count:uint = 0;
			var rsp$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (task_inf$count != 0) {
						throw new flash.errors.IOError('Bad data format: SAcceptTaskRsp.taskInf cannot be set twice.');
					}
					++task_inf$count;
					this.taskInf = new com.msg.task.TaskInf();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.taskInf);
					break;
				case 2:
					if (rsp$count != 0) {
						throw new flash.errors.IOError('Bad data format: SAcceptTaskRsp.rsp cannot be set twice.');
					}
					++rsp$count;
					this.rsp = com.netease.protobuf.ReadUtils.read$TYPE_ENUM(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
