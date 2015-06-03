package com.msg.task {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.msg.enumdef.TaskTargetType;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class TaskTagInf extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const TAG_TYPE:FieldDescriptor$TYPE_ENUM = new FieldDescriptor$TYPE_ENUM("com.msg.task.TaskTagInf.tag_type", "tagType", (1 << 3) | com.netease.protobuf.WireType.VARINT, com.msg.enumdef.TaskTargetType);

		public var tagType:int;

		/**
		 *  @private
		 */
		public static const TAG_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.task.TaskTagInf.tag_id", "tagId", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var tagId:int;

		/**
		 *  @private
		 */
		public static const TOTAL_NUM:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.task.TaskTagInf.total_num", "totalNum", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		public var totalNum:int;

		/**
		 *  @private
		 */
		public static const CUR_NUM:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.task.TaskTagInf.cur_num", "curNum", (4 << 3) | com.netease.protobuf.WireType.VARINT);

		public var curNum:int;

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_ENUM(output, this.tagType);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.tagId);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.totalNum);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 4);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.curNum);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var tag_type$count:uint = 0;
			var tag_id$count:uint = 0;
			var total_num$count:uint = 0;
			var cur_num$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (tag_type$count != 0) {
						throw new flash.errors.IOError('Bad data format: TaskTagInf.tagType cannot be set twice.');
					}
					++tag_type$count;
					this.tagType = com.netease.protobuf.ReadUtils.read$TYPE_ENUM(input);
					break;
				case 2:
					if (tag_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: TaskTagInf.tagId cannot be set twice.');
					}
					++tag_id$count;
					this.tagId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					if (total_num$count != 0) {
						throw new flash.errors.IOError('Bad data format: TaskTagInf.totalNum cannot be set twice.');
					}
					++total_num$count;
					this.totalNum = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 4:
					if (cur_num$count != 0) {
						throw new flash.errors.IOError('Bad data format: TaskTagInf.curNum cannot be set twice.');
					}
					++cur_num$count;
					this.curNum = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
