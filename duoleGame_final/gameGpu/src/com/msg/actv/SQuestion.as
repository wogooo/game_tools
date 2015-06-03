package com.msg.actv {
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
	public dynamic final class SQuestion extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const QUESTION_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.actv.SQuestion.question_id", "questionId", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var questionId:int;

		/**
		 *  @private
		 */
		public static const QUESTION_NUMBER:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.actv.SQuestion.question_number", "questionNumber", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var questionNumber:int;

		/**
		 *  @private
		 */
		public static const RIGHT_NUMBER:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.actv.SQuestion.right_number", "rightNumber", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		private var right_number$field:int;

		private var hasField$0:uint = 0;

		public function clearRightNumber():void {
			hasField$0 &= 0xfffffffe;
			right_number$field = new int();
		}

		public function get hasRightNumber():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set rightNumber(value:int):void {
			hasField$0 |= 0x1;
			right_number$field = value;
		}

		public function get rightNumber():int {
			return right_number$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.questionId);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.questionNumber);
			if (hasRightNumber) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, right_number$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var question_id$count:uint = 0;
			var question_number$count:uint = 0;
			var right_number$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (question_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: SQuestion.questionId cannot be set twice.');
					}
					++question_id$count;
					this.questionId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (question_number$count != 0) {
						throw new flash.errors.IOError('Bad data format: SQuestion.questionNumber cannot be set twice.');
					}
					++question_number$count;
					this.questionNumber = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					if (right_number$count != 0) {
						throw new flash.errors.IOError('Bad data format: SQuestion.rightNumber cannot be set twice.');
					}
					++right_number$count;
					this.rightNumber = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
