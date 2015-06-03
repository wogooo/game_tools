package com.msg.mount_pro {
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
	public dynamic final class CExchangeMount extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const MAIN_MOUNT_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.mount_pro.CExchangeMount.main_mount_id", "mainMountId", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var mainMountId:int;

		/**
		 *  @private
		 */
		public static const DEPUTY_MOUNT_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.mount_pro.CExchangeMount.deputy_mount_id", "deputyMountId", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var deputyMountId:int;

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.mainMountId);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.deputyMountId);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var main_mount_id$count:uint = 0;
			var deputy_mount_id$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (main_mount_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: CExchangeMount.mainMountId cannot be set twice.');
					}
					++main_mount_id$count;
					this.mainMountId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (deputy_mount_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: CExchangeMount.deputyMountId cannot be set twice.');
					}
					++deputy_mount_id$count;
					this.deputyMountId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
