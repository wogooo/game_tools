package com.msg.mount_pro {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.msg.mount_pro.MountInfo;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class SMountList extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const MOUNT_INFO_ARR:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.msg.mount_pro.SMountList.mount_info_arr", "mountInfoArr", (1 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.msg.mount_pro.MountInfo; });

		[ArrayElementType("com.msg.mount_pro.MountInfo")]
		public var mountInfoArr:Array = [];

		/**
		 *  @private
		 */
		public static const FIGHT_MOUNT_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.mount_pro.SMountList.fight_mount_id", "fightMountId", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var fightMountId:int;

		/**
		 *  @private
		 */
		public static const IS_MOUNT:FieldDescriptor$TYPE_BOOL = new FieldDescriptor$TYPE_BOOL("com.msg.mount_pro.SMountList.is_mount", "isMount", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		public var isMount:Boolean;

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			for (var mountInfoArr$index:uint = 0; mountInfoArr$index < this.mountInfoArr.length; ++mountInfoArr$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 1);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.mountInfoArr[mountInfoArr$index]);
			}
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.fightMountId);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
			com.netease.protobuf.WriteUtils.write$TYPE_BOOL(output, this.isMount);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var fight_mount_id$count:uint = 0;
			var is_mount$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					this.mountInfoArr.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.msg.mount_pro.MountInfo()));
					break;
				case 2:
					if (fight_mount_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: SMountList.fightMountId cannot be set twice.');
					}
					++fight_mount_id$count;
					this.fightMountId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					if (is_mount$count != 0) {
						throw new flash.errors.IOError('Bad data format: SMountList.isMount cannot be set twice.');
					}
					++is_mount$count;
					this.isMount = com.netease.protobuf.ReadUtils.read$TYPE_BOOL(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
