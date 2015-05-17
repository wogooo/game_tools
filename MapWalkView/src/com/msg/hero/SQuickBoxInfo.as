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
	public dynamic final class SQuickBoxInfo extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const QUICK_BOX_ARR:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.msg.hero.SQuickBoxInfo.quick_box_arr", "quickBoxArr", (1 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.msg.hero.QuickBox; });

		[ArrayElementType("com.msg.hero.QuickBox")]
		public var quickBoxArr:Array = [];

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			for (var quickBoxArr$index:uint = 0; quickBoxArr$index < this.quickBoxArr.length; ++quickBoxArr$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 1);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.quickBoxArr[quickBoxArr$index]);
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
					this.quickBoxArr.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.msg.hero.QuickBox()));
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
