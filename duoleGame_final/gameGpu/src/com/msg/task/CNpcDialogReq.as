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
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class CNpcDialogReq extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const TASK_INF:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.msg.task.CNpcDialogReq.task_inf", "taskInf", (1 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.msg.task.TaskInf; });

		public var taskInf:com.msg.task.TaskInf;

		/**
		 *  @private
		 */
		public static const NPC_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.task.CNpcDialogReq.npc_id", "npcId", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var npcId:int;

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.taskInf);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.npcId);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var task_inf$count:uint = 0;
			var npc_id$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (task_inf$count != 0) {
						throw new flash.errors.IOError('Bad data format: CNpcDialogReq.taskInf cannot be set twice.');
					}
					++task_inf$count;
					this.taskInf = new com.msg.task.TaskInf();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.taskInf);
					break;
				case 2:
					if (npc_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: CNpcDialogReq.npcId cannot be set twice.');
					}
					++npc_id$count;
					this.npcId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
