package com.msg.grow_task {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.msg.grow_task.GrowTaskStatus;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class SGrowTaskList extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const GROW_TASK_ARR:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.msg.grow_task.SGrowTaskList.grow_task_arr", "growTaskArr", (1 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.msg.grow_task.GrowTaskStatus; });

		[ArrayElementType("com.msg.grow_task.GrowTaskStatus")]
		public var growTaskArr:Array = [];

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			for (var growTaskArr$index:uint = 0; growTaskArr$index < this.growTaskArr.length; ++growTaskArr$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 1);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.growTaskArr[growTaskArr$index]);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					this.growTaskArr.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.msg.grow_task.GrowTaskStatus()));
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
