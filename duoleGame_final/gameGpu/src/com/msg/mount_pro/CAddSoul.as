package com.msg.mount_pro {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.msg.common.ItemConsume;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class CAddSoul extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const MOUNT_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.mount_pro.CAddSoul.mount_id", "mountId", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var mountId:int;

		/**
		 *  @private
		 */
		public static const USE_ITEM:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.msg.mount_pro.CAddSoul.use_item", "useItem", (2 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.msg.common.ItemConsume; });

		[ArrayElementType("com.msg.common.ItemConsume")]
		public var useItem:Array = [];

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.mountId);
			for (var useItem$index:uint = 0; useItem$index < this.useItem.length; ++useItem$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.useItem[useItem$index]);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var mount_id$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (mount_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: CAddSoul.mountId cannot be set twice.');
					}
					++mount_id$count;
					this.mountId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					this.useItem.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.msg.common.ItemConsume()));
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
