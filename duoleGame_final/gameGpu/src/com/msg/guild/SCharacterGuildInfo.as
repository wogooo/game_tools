package com.msg.guild {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.msg.guild.GuildDetailInfo;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class SCharacterGuildInfo extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const GUILD_INFO:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.msg.guild.SCharacterGuildInfo.guild_info", "guildInfo", (1 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.msg.guild.GuildDetailInfo; });

		private var guild_info$field:com.msg.guild.GuildDetailInfo;

		public function clearGuildInfo():void {
			guild_info$field = null;
		}

		public function get hasGuildInfo():Boolean {
			return guild_info$field != null;
		}

		public function set guildInfo(value:com.msg.guild.GuildDetailInfo):void {
			guild_info$field = value;
		}

		public function get guildInfo():com.msg.guild.GuildDetailInfo {
			return guild_info$field;
		}

		/**
		 *  @private
		 */
		public static const ACCUSER_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.guild.SCharacterGuildInfo.accuser_id", "accuserId", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		private var accuser_id$field:int;

		private var hasField$0:uint = 0;

		public function clearAccuserId():void {
			hasField$0 &= 0xfffffffe;
			accuser_id$field = new int();
		}

		public function get hasAccuserId():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set accuserId(value:int):void {
			hasField$0 |= 0x1;
			accuser_id$field = value;
		}

		public function get accuserId():int {
			return accuser_id$field;
		}

		/**
		 *  @private
		 */
		public static const VOTE_STATE:FieldDescriptor$TYPE_BOOL = new FieldDescriptor$TYPE_BOOL("com.msg.guild.SCharacterGuildInfo.vote_state", "voteState", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		private var vote_state$field:Boolean;

		public function clearVoteState():void {
			hasField$0 &= 0xfffffffd;
			vote_state$field = new Boolean();
		}

		public function get hasVoteState():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set voteState(value:Boolean):void {
			hasField$0 |= 0x2;
			vote_state$field = value;
		}

		public function get voteState():Boolean {
			return vote_state$field;
		}

		/**
		 *  @private
		 */
		public static const FINISH_TIME:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.guild.SCharacterGuildInfo.finish_time", "finishTime", (4 << 3) | com.netease.protobuf.WireType.VARINT);

		private var finish_time$field:int;

		public function clearFinishTime():void {
			hasField$0 &= 0xfffffffb;
			finish_time$field = new int();
		}

		public function get hasFinishTime():Boolean {
			return (hasField$0 & 0x4) != 0;
		}

		public function set finishTime(value:int):void {
			hasField$0 |= 0x4;
			finish_time$field = value;
		}

		public function get finishTime():int {
			return finish_time$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			if (hasGuildInfo) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 1);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, guild_info$field);
			}
			if (hasAccuserId) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, accuser_id$field);
			}
			if (hasVoteState) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_BOOL(output, vote_state$field);
			}
			if (hasFinishTime) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 4);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, finish_time$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var guild_info$count:uint = 0;
			var accuser_id$count:uint = 0;
			var vote_state$count:uint = 0;
			var finish_time$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (guild_info$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCharacterGuildInfo.guildInfo cannot be set twice.');
					}
					++guild_info$count;
					this.guildInfo = new com.msg.guild.GuildDetailInfo();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.guildInfo);
					break;
				case 2:
					if (accuser_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCharacterGuildInfo.accuserId cannot be set twice.');
					}
					++accuser_id$count;
					this.accuserId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					if (vote_state$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCharacterGuildInfo.voteState cannot be set twice.');
					}
					++vote_state$count;
					this.voteState = com.netease.protobuf.ReadUtils.read$TYPE_BOOL(input);
					break;
				case 4:
					if (finish_time$count != 0) {
						throw new flash.errors.IOError('Bad data format: SCharacterGuildInfo.finishTime cannot be set twice.');
					}
					++finish_time$count;
					this.finishTime = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
