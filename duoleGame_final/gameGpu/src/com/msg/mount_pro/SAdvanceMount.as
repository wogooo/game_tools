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
	public dynamic final class SAdvanceMount extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const ERROR_INFO:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.mount_pro.SAdvanceMount.error_info", "errorInfo", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var errorInfo:int;

		/**
		 *  @private
		 */
		public static const MOUNT_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.mount_pro.SAdvanceMount.mount_id", "mountId", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var mountId:int;

		/**
		 *  @private
		 */
		public static const NEW_BASIC_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.mount_pro.SAdvanceMount.new_basic_id", "newBasicId", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		private var new_basic_id$field:int;

		private var hasField$0:uint = 0;

		public function clearNewBasicId():void {
			hasField$0 &= 0xfffffffe;
			new_basic_id$field = new int();
		}

		public function get hasNewBasicId():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set newBasicId(value:int):void {
			hasField$0 |= 0x1;
			new_basic_id$field = value;
		}

		public function get newBasicId():int {
			return new_basic_id$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.errorInfo);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.mountId);
			if (hasNewBasicId) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, new_basic_id$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var error_info$count:uint = 0;
			var mount_id$count:uint = 0;
			var new_basic_id$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (error_info$count != 0) {
						throw new flash.errors.IOError('Bad data format: SAdvanceMount.errorInfo cannot be set twice.');
					}
					++error_info$count;
					this.errorInfo = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (mount_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: SAdvanceMount.mountId cannot be set twice.');
					}
					++mount_id$count;
					this.mountId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					if (new_basic_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: SAdvanceMount.newBasicId cannot be set twice.');
					}
					++new_basic_id$count;
					this.newBasicId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
