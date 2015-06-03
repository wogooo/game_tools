package com.msg.login {
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
	public dynamic final class CLogin extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const COUNT_ID:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.msg.login.CLogin.count_id", "countId", (1 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var countId:String;

		/**
		 *  @private
		 */
		public static const CLIENT_IP:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.msg.login.CLogin.client_ip", "clientIp", (2 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		private var client_ip$field:String;

		public function clearClientIp():void {
			client_ip$field = null;
		}

		public function get hasClientIp():Boolean {
			return client_ip$field != null;
		}

		public function set clientIp(value:String):void {
			client_ip$field = value;
		}

		public function get clientIp():String {
			return client_ip$field;
		}

		/**
		 *  @private
		 */
		public static const USER_KEY:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.msg.login.CLogin.user_key", "userKey", (3 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		private var user_key$field:String;

		public function clearUserKey():void {
			user_key$field = null;
		}

		public function get hasUserKey():Boolean {
			return user_key$field != null;
		}

		public function set userKey(value:String):void {
			user_key$field = value;
		}

		public function get userKey():String {
			return user_key$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.countId);
			if (hasClientIp) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, client_ip$field);
			}
			if (hasUserKey) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, user_key$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var count_id$count:uint = 0;
			var client_ip$count:uint = 0;
			var user_key$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (count_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: CLogin.countId cannot be set twice.');
					}
					++count_id$count;
					this.countId = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 2:
					if (client_ip$count != 0) {
						throw new flash.errors.IOError('Bad data format: CLogin.clientIp cannot be set twice.');
					}
					++client_ip$count;
					this.clientIp = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 3:
					if (user_key$count != 0) {
						throw new flash.errors.IOError('Bad data format: CLogin.userKey cannot be set twice.');
					}
					++user_key$count;
					this.userKey = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
