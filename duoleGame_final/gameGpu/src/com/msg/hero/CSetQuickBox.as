package com.msg.hero {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.msg.hero.QuickBox;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class CSetQuickBox extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const FROM_BOX_INFO:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.msg.hero.CSetQuickBox.from_box_info", "fromBoxInfo", (1 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.msg.hero.QuickBox; });

		public var fromBoxInfo:com.msg.hero.QuickBox;

		/**
		 *  @private
		 */
		public static const TARGET_KEY_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.hero.CSetQuickBox.target_key_id", "targetKeyId", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var targetKeyId:int;

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.fromBoxInfo);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.targetKeyId);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var from_box_info$count:uint = 0;
			var target_key_id$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (from_box_info$count != 0) {
						throw new flash.errors.IOError('Bad data format: CSetQuickBox.fromBoxInfo cannot be set twice.');
					}
					++from_box_info$count;
					this.fromBoxInfo = new com.msg.hero.QuickBox();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.fromBoxInfo);
					break;
				case 2:
					if (target_key_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: CSetQuickBox.targetKeyId cannot be set twice.');
					}
					++target_key_id$count;
					this.targetKeyId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
