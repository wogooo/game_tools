package com.msg.chat {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.msg.chat.Response;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class SForwardAddFriendRsp extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const RSP:FieldDescriptor$TYPE_ENUM = new FieldDescriptor$TYPE_ENUM("com.msg.chat.SForwardAddFriendRsp.rsp", "rsp", (1 << 3) | com.netease.protobuf.WireType.VARINT, com.msg.chat.Response);

		public var rsp:int;

		/**
		 *  @private
		 */
		public static const FROM_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.chat.SForwardAddFriendRsp.from_id", "fromId", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var fromId:int;

		/**
		 *  @private
		 */
		public static const FROM_NAME:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.msg.chat.SForwardAddFriendRsp.from_name", "fromName", (3 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var fromName:String;

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_ENUM(output, this.rsp);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.fromId);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 3);
			com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.fromName);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var rsp$count:uint = 0;
			var from_id$count:uint = 0;
			var from_name$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (rsp$count != 0) {
						throw new flash.errors.IOError('Bad data format: SForwardAddFriendRsp.rsp cannot be set twice.');
					}
					++rsp$count;
					this.rsp = com.netease.protobuf.ReadUtils.read$TYPE_ENUM(input);
					break;
				case 2:
					if (from_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: SForwardAddFriendRsp.fromId cannot be set twice.');
					}
					++from_id$count;
					this.fromId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					if (from_name$count != 0) {
						throw new flash.errors.IOError('Bad data format: SForwardAddFriendRsp.fromName cannot be set twice.');
					}
					++from_name$count;
					this.fromName = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
