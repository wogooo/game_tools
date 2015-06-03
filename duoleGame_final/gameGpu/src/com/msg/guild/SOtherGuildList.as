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
	public dynamic final class SOtherGuildList extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const TOTAL_PAGE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.guild.SOtherGuildList.total_page", "totalPage", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var totalPage:int;

		/**
		 *  @private
		 */
		public static const CURRENT_PAGE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.guild.SOtherGuildList.current_page", "currentPage", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var currentPage:int;

		/**
		 *  @private
		 */
		public static const GUILD_INFO_ARR:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.msg.guild.SOtherGuildList.guild_info_arr", "guildInfoArr", (3 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.msg.guild.GuildInfo; });

		[ArrayElementType("com.msg.guild.GuildInfo")]
		public var guildInfoArr:Array = [];

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.totalPage);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.currentPage);
			for (var guildInfoArr$index:uint = 0; guildInfoArr$index < this.guildInfoArr.length; ++guildInfoArr$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.guildInfoArr[guildInfoArr$index]);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var total_page$count:uint = 0;
			var current_page$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (total_page$count != 0) {
						throw new flash.errors.IOError('Bad data format: SOtherGuildList.totalPage cannot be set twice.');
					}
					++total_page$count;
					this.totalPage = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (current_page$count != 0) {
						throw new flash.errors.IOError('Bad data format: SOtherGuildList.currentPage cannot be set twice.');
					}
					++current_page$count;
					this.currentPage = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					this.guildInfoArr.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.msg.guild.GuildInfo()));
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
