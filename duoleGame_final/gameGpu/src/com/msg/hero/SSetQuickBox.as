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
	public dynamic final class SSetQuickBox extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const CODE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.hero.SSetQuickBox.code", "code", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var code:int;

		/**
		 *  @private
		 */
		public static const NEW_BOX_INFO:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.msg.hero.SSetQuickBox.new_box_info", "newBoxInfo", (2 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.msg.hero.QuickBox; });

		public var newBoxInfo:com.msg.hero.QuickBox;

		/**
		 *  @private
		 */
		public static const OLD_BOX_INFO:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.msg.hero.SSetQuickBox.old_box_info", "oldBoxInfo", (3 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.msg.hero.QuickBox; });

		public var oldBoxInfo:com.msg.hero.QuickBox;

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.code);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.newBoxInfo);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 3);
			com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.oldBoxInfo);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var code$count:uint = 0;
			var new_box_info$count:uint = 0;
			var old_box_info$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (code$count != 0) {
						throw new flash.errors.IOError('Bad data format: SSetQuickBox.code cannot be set twice.');
					}
					++code$count;
					this.code = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (new_box_info$count != 0) {
						throw new flash.errors.IOError('Bad data format: SSetQuickBox.newBoxInfo cannot be set twice.');
					}
					++new_box_info$count;
					this.newBoxInfo = new com.msg.hero.QuickBox();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.newBoxInfo);
					break;
				case 3:
					if (old_box_info$count != 0) {
						throw new flash.errors.IOError('Bad data format: SSetQuickBox.oldBoxInfo cannot be set twice.');
					}
					++old_box_info$count;
					this.oldBoxInfo = new com.msg.hero.QuickBox();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.oldBoxInfo);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
