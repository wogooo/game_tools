package com.msg.guild {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.msg.guild.GuildMember;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class GuildDetailInfo extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const GUILD_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.guild.GuildDetailInfo.guild_id", "guildId", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var guildId:int;

		/**
		 *  @private
		 */
		public static const GUILD_LEVEL:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.guild.GuildDetailInfo.guild_level", "guildLevel", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var guildLevel:int;

		/**
		 *  @private
		 */
		public static const MAX_MEMBER_NUMBER:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.guild.GuildDetailInfo.max_member_number", "maxMemberNumber", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		public var maxMemberNumber:int;

		/**
		 *  @private
		 */
		public static const MONEY:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.guild.GuildDetailInfo.money", "money", (4 << 3) | com.netease.protobuf.WireType.VARINT);

		public var money:int;

		/**
		 *  @private
		 */
		public static const NAME:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.msg.guild.GuildDetailInfo.name", "name", (5 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var name:String;

		/**
		 *  @private
		 */
		public static const NOTICE:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.msg.guild.GuildDetailInfo.notice", "notice", (6 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var notice:String;

		/**
		 *  @private
		 */
		public static const GUILD_MEMBER_ARR:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.msg.guild.GuildDetailInfo.guild_member_arr", "guildMemberArr", (7 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.msg.guild.GuildMember; });

		[ArrayElementType("com.msg.guild.GuildMember")]
		public var guildMemberArr:Array = [];

		/**
		 *  @private
		 */
		public static const RESEARCH_LEVEL:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.guild.GuildDetailInfo.research_level", "researchLevel", (8 << 3) | com.netease.protobuf.WireType.VARINT);

		public var researchLevel:int;

		/**
		 *  @private
		 */
		public static const SHOP_LEVEL:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.guild.GuildDetailInfo.shop_level", "shopLevel", (9 << 3) | com.netease.protobuf.WireType.VARINT);

		public var shopLevel:int;

		/**
		 *  @private
		 */
		public static const HOUSE_LEVEL:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.guild.GuildDetailInfo.house_level", "houseLevel", (10 << 3) | com.netease.protobuf.WireType.VARINT);

		public var houseLevel:int;

		/**
		 *  @private
		 */
		public static const STORAGE_LEVEL:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.guild.GuildDetailInfo.storage_level", "storageLevel", (11 << 3) | com.netease.protobuf.WireType.VARINT);

		public var storageLevel:int;

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.guildId);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.guildLevel);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.maxMemberNumber);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 4);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.money);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 5);
			com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.name);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 6);
			com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.notice);
			for (var guildMemberArr$index:uint = 0; guildMemberArr$index < this.guildMemberArr.length; ++guildMemberArr$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 7);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.guildMemberArr[guildMemberArr$index]);
			}
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 8);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.researchLevel);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 9);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.shopLevel);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 10);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.houseLevel);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 11);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.storageLevel);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var guild_id$count:uint = 0;
			var guild_level$count:uint = 0;
			var max_member_number$count:uint = 0;
			var money$count:uint = 0;
			var name$count:uint = 0;
			var notice$count:uint = 0;
			var research_level$count:uint = 0;
			var shop_level$count:uint = 0;
			var house_level$count:uint = 0;
			var storage_level$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (guild_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: GuildDetailInfo.guildId cannot be set twice.');
					}
					++guild_id$count;
					this.guildId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (guild_level$count != 0) {
						throw new flash.errors.IOError('Bad data format: GuildDetailInfo.guildLevel cannot be set twice.');
					}
					++guild_level$count;
					this.guildLevel = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					if (max_member_number$count != 0) {
						throw new flash.errors.IOError('Bad data format: GuildDetailInfo.maxMemberNumber cannot be set twice.');
					}
					++max_member_number$count;
					this.maxMemberNumber = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 4:
					if (money$count != 0) {
						throw new flash.errors.IOError('Bad data format: GuildDetailInfo.money cannot be set twice.');
					}
					++money$count;
					this.money = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 5:
					if (name$count != 0) {
						throw new flash.errors.IOError('Bad data format: GuildDetailInfo.name cannot be set twice.');
					}
					++name$count;
					this.name = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 6:
					if (notice$count != 0) {
						throw new flash.errors.IOError('Bad data format: GuildDetailInfo.notice cannot be set twice.');
					}
					++notice$count;
					this.notice = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 7:
					this.guildMemberArr.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.msg.guild.GuildMember()));
					break;
				case 8:
					if (research_level$count != 0) {
						throw new flash.errors.IOError('Bad data format: GuildDetailInfo.researchLevel cannot be set twice.');
					}
					++research_level$count;
					this.researchLevel = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 9:
					if (shop_level$count != 0) {
						throw new flash.errors.IOError('Bad data format: GuildDetailInfo.shopLevel cannot be set twice.');
					}
					++shop_level$count;
					this.shopLevel = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 10:
					if (house_level$count != 0) {
						throw new flash.errors.IOError('Bad data format: GuildDetailInfo.houseLevel cannot be set twice.');
					}
					++house_level$count;
					this.houseLevel = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 11:
					if (storage_level$count != 0) {
						throw new flash.errors.IOError('Bad data format: GuildDetailInfo.storageLevel cannot be set twice.');
					}
					++storage_level$count;
					this.storageLevel = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
