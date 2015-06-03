package com.msg.hero {
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
	public dynamic final class SUpdateMountLucky extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const LUCKY:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.hero.SUpdateMountLucky.lucky", "lucky", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var lucky:int;

		/**
		 *  @private
		 */
		public static const IS_LUCKY:FieldDescriptor$TYPE_BOOL = new FieldDescriptor$TYPE_BOOL("com.msg.hero.SUpdateMountLucky.is_lucky", "isLucky", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var isLucky:Boolean;

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.lucky);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_BOOL(output, this.isLucky);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var lucky$count:uint = 0;
			var is_lucky$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (lucky$count != 0) {
						throw new flash.errors.IOError('Bad data format: SUpdateMountLucky.lucky cannot be set twice.');
					}
					++lucky$count;
					this.lucky = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (is_lucky$count != 0) {
						throw new flash.errors.IOError('Bad data format: SUpdateMountLucky.isLucky cannot be set twice.');
					}
					++is_lucky$count;
					this.isLucky = com.netease.protobuf.ReadUtils.read$TYPE_BOOL(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
