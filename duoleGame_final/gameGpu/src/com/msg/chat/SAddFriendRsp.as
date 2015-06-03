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
	public dynamic final class SAddFriendRsp extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const RSP:FieldDescriptor$TYPE_ENUM = new FieldDescriptor$TYPE_ENUM("com.msg.chat.SAddFriendRsp.rsp", "rsp", (1 << 3) | com.netease.protobuf.WireType.VARINT, com.msg.chat.Response);

		public var rsp:int;

		/**
		 *  @private
		 */
		public static const TO_NAME:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.msg.chat.SAddFriendRsp.to_name", "toName", (2 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var toName:String;

		/**
		 *  @private
		 */
		public static const TO_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.chat.SAddFriendRsp.to_id", "toId", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		private var to_id$field:int;

		private var hasField$0:uint = 0;

		public function clearToId():void {
			hasField$0 &= 0xfffffffe;
			to_id$field = new int();
		}

		public function get hasToId():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set toId(value:int):void {
			hasField$0 |= 0x1;
			to_id$field = value;
		}

		public function get toId():int {
			return to_id$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_ENUM(output, this.rsp);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.toName);
			if (hasToId) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, to_id$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var rsp$count:uint = 0;
			var to_name$count:uint = 0;
			var to_id$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (rsp$count != 0) {
						throw new flash.errors.IOError('Bad data format: SAddFriendRsp.rsp cannot be set twice.');
					}
					++rsp$count;
					this.rsp = com.netease.protobuf.ReadUtils.read$TYPE_ENUM(input);
					break;
				case 2:
					if (to_name$count != 0) {
						throw new flash.errors.IOError('Bad data format: SAddFriendRsp.toName cannot be set twice.');
					}
					++to_name$count;
					this.toName = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 3:
					if (to_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: SAddFriendRsp.toId cannot be set twice.');
					}
					++to_id$count;
					this.toId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
