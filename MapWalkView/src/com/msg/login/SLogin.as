package com.msg.login {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.msg.login.PlayerInfo;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class SLogin extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const CODE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.login.SLogin.code", "code", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var code:int;

		/**
		 *  @private
		 */
		public static const PLAYER_INFO:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.msg.login.SLogin.player_info", "playerInfo", (2 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.msg.login.PlayerInfo; });

		private var player_info$field:com.msg.login.PlayerInfo;

		public function clearPlayerInfo():void {
			player_info$field = null;
		}

		public function get hasPlayerInfo():Boolean {
			return player_info$field != null;
		}

		public function set playerInfo(value:com.msg.login.PlayerInfo):void {
			player_info$field = value;
		}

		public function get playerInfo():com.msg.login.PlayerInfo {
			return player_info$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.code);
			if (hasPlayerInfo) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, player_info$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var code$count:uint = 0;
			var player_info$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (code$count != 0) {
						throw new flash.errors.IOError('Bad data format: SLogin.code cannot be set twice.');
					}
					++code$count;
					this.code = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (player_info$count != 0) {
						throw new flash.errors.IOError('Bad data format: SLogin.playerInfo cannot be set twice.');
					}
					++player_info$count;
					this.playerInfo = new com.msg.login.PlayerInfo();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.playerInfo);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
