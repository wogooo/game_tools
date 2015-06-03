package com.msg.guild {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.msg.guild.GuildInfo;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class SQueryGuildInfo extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const SIMPLE_INFO:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.msg.guild.SQueryGuildInfo.simple_info", "simpleInfo", (1 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.msg.guild.GuildInfo; });

		public var simpleInfo:com.msg.guild.GuildInfo;

		/**
		 *  @private
		 */
		public static const MONEY:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.guild.SQueryGuildInfo.money", "money", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var money:int;

		/**
		 *  @private
		 */
		public static const NOTICE:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.msg.guild.SQueryGuildInfo.notice", "notice", (3 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var notice:String;

		/**
		 *  @private
		 */
		public static const MAX_MONEY:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.guild.SQueryGuildInfo.max_money", "maxMoney", (4 << 3) | com.netease.protobuf.WireType.VARINT);

		public var maxMoney:int;

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.simpleInfo);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.money);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 3);
			com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.notice);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 4);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.maxMoney);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var simple_info$count:uint = 0;
			var money$count:uint = 0;
			var notice$count:uint = 0;
			var max_money$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (simple_info$count != 0) {
						throw new flash.errors.IOError('Bad data format: SQueryGuildInfo.simpleInfo cannot be set twice.');
					}
					++simple_info$count;
					this.simpleInfo = new com.msg.guild.GuildInfo();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.simpleInfo);
					break;
				case 2:
					if (money$count != 0) {
						throw new flash.errors.IOError('Bad data format: SQueryGuildInfo.money cannot be set twice.');
					}
					++money$count;
					this.money = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					if (notice$count != 0) {
						throw new flash.errors.IOError('Bad data format: SQueryGuildInfo.notice cannot be set twice.');
					}
					++notice$count;
					this.notice = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 4:
					if (max_money$count != 0) {
						throw new flash.errors.IOError('Bad data format: SQueryGuildInfo.maxMoney cannot be set twice.');
					}
					++max_money$count;
					this.maxMoney = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
