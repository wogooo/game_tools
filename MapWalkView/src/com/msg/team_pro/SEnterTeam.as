package com.msg.team_pro {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.msg.team_pro.MemberInfo;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class SEnterTeam extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const ERROR_INFO:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.team_pro.SEnterTeam.error_info", "errorInfo", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var errorInfo:int;

		/**
		 *  @private
		 */
		public static const LEADER_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.team_pro.SEnterTeam.leader_id", "leaderId", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var leaderId:int;

		/**
		 *  @private
		 */
		public static const MEMBERS:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.msg.team_pro.SEnterTeam.members", "members", (3 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.msg.team_pro.MemberInfo; });

		[ArrayElementType("com.msg.team_pro.MemberInfo")]
		public var members:Array = [];

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.errorInfo);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.leaderId);
			for (var members$index:uint = 0; members$index < this.members.length; ++members$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.members[members$index]);
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
			var leader_id$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (error_info$count != 0) {
						throw new flash.errors.IOError('Bad data format: SEnterTeam.errorInfo cannot be set twice.');
					}
					++error_info$count;
					this.errorInfo = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (leader_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: SEnterTeam.leaderId cannot be set twice.');
					}
					++leader_id$count;
					this.leaderId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					this.members.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.msg.team_pro.MemberInfo()));
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
