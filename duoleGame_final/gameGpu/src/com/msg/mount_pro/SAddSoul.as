package com.msg.mount_pro {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.msg.mount_pro.MountAttr;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class SAddSoul extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const MOUNT_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.mount_pro.SAddSoul.mount_id", "mountId", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var mountId:int;

		/**
		 *  @private
		 */
		public static const MOUNT_ADD_ATTR:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.msg.mount_pro.SAddSoul.mount_add_attr", "mountAddAttr", (2 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.msg.mount_pro.MountAttr; });

		public var mountAddAttr:com.msg.mount_pro.MountAttr;

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.mountId);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.mountAddAttr);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var mount_id$count:uint = 0;
			var mount_add_attr$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (mount_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: SAddSoul.mountId cannot be set twice.');
					}
					++mount_id$count;
					this.mountId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (mount_add_attr$count != 0) {
						throw new flash.errors.IOError('Bad data format: SAddSoul.mountAddAttr cannot be set twice.');
					}
					++mount_add_attr$count;
					this.mountAddAttr = new com.msg.mount_pro.MountAttr();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.mountAddAttr);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
