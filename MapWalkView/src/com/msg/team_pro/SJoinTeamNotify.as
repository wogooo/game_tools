package com.msg.team_pro {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.msg.team_pro.PasserbyInfo;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class SJoinTeamNotify extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const JOIN_REQUESTER:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.msg.team_pro.SJoinTeamNotify.join_requester", "joinRequester", (1 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.msg.team_pro.PasserbyInfo; });

		public var joinRequester:com.msg.team_pro.PasserbyInfo;

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.joinRequester);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var join_requester$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (join_requester$count != 0) {
						throw new flash.errors.IOError('Bad data format: SJoinTeamNotify.joinRequester cannot be set twice.');
					}
					++join_requester$count;
					this.joinRequester = new com.msg.team_pro.PasserbyInfo();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.joinRequester);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
