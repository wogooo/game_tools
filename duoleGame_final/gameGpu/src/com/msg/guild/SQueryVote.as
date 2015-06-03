package com.msg.guild {
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
	public dynamic final class SQueryVote extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const SUPPORT_NUMBER:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.guild.SQueryVote.support_number", "supportNumber", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var supportNumber:int;

		/**
		 *  @private
		 */
		public static const NOT_SUPPORT_NUMBER:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.guild.SQueryVote.not_support_number", "notSupportNumber", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var notSupportNumber:int;

		/**
		 *  @private
		 */
		public static const TOTAL_NUMBER:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.guild.SQueryVote.total_number", "totalNumber", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		public var totalNumber:int;

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.supportNumber);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.notSupportNumber);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.totalNumber);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var support_number$count:uint = 0;
			var not_support_number$count:uint = 0;
			var total_number$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (support_number$count != 0) {
						throw new flash.errors.IOError('Bad data format: SQueryVote.supportNumber cannot be set twice.');
					}
					++support_number$count;
					this.supportNumber = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (not_support_number$count != 0) {
						throw new flash.errors.IOError('Bad data format: SQueryVote.notSupportNumber cannot be set twice.');
					}
					++not_support_number$count;
					this.notSupportNumber = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					if (total_number$count != 0) {
						throw new flash.errors.IOError('Bad data format: SQueryVote.totalNumber cannot be set twice.');
					}
					++total_number$count;
					this.totalNumber = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
