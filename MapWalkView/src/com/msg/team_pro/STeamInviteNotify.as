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
	public dynamic final class STeamInviteNotify extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const INVITOR_INFO:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.msg.team_pro.STeamInviteNotify.invitor_info", "invitorInfo", (1 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.msg.team_pro.PasserbyInfo; });

		public var invitorInfo:com.msg.team_pro.PasserbyInfo;

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.invitorInfo);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var invitor_info$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (invitor_info$count != 0) {
						throw new flash.errors.IOError('Bad data format: STeamInviteNotify.invitorInfo cannot be set twice.');
					}
					++invitor_info$count;
					this.invitorInfo = new com.msg.team_pro.PasserbyInfo();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.invitorInfo);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
