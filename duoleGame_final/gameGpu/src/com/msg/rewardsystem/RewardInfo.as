package com.msg.rewardsystem {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.msg.rewardsystem.RewardGMInfo;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class RewardInfo extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const RS_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.rewardsystem.RewardInfo.rs_id", "rsId", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var rsId:int;

		/**
		 *  @private
		 */
		public static const REWARD_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.rewardsystem.RewardInfo.reward_id", "rewardId", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var rewardId:int;

		/**
		 *  @private
		 */
		public static const REWARD_TYPE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.rewardsystem.RewardInfo.reward_type", "rewardType", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		public var rewardType:int;

		/**
		 *  @private
		 */
		public static const REWARD_TIME:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.rewardsystem.RewardInfo.reward_time", "rewardTime", (4 << 3) | com.netease.protobuf.WireType.VARINT);

		public var rewardTime:int;

		/**
		 *  @private
		 */
		public static const REWARD_GM_INFO:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.msg.rewardsystem.RewardInfo.reward_gm_info", "rewardGmInfo", (5 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.msg.rewardsystem.RewardGMInfo; });

		[ArrayElementType("com.msg.rewardsystem.RewardGMInfo")]
		public var rewardGmInfo:Array = [];

		/**
		 *  @private
		 */
		public static const KEEP_TIME:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.rewardsystem.RewardInfo.keep_time", "keepTime", (6 << 3) | com.netease.protobuf.WireType.VARINT);

		private var keep_time$field:int;

		private var hasField$0:uint = 0;

		public function clearKeepTime():void {
			hasField$0 &= 0xfffffffe;
			keep_time$field = new int();
		}

		public function get hasKeepTime():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set keepTime(value:int):void {
			hasField$0 |= 0x1;
			keep_time$field = value;
		}

		public function get keepTime():int {
			return keep_time$field;
		}

		/**
		 *  @private
		 */
		public static const TITLE:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.msg.rewardsystem.RewardInfo.title", "title", (7 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		private var title$field:String;

		public function clearTitle():void {
			title$field = null;
		}

		public function get hasTitle():Boolean {
			return title$field != null;
		}

		public function set title(value:String):void {
			title$field = value;
		}

		public function get title():String {
			return title$field;
		}

		/**
		 *  @private
		 */
		public static const MATTER:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.msg.rewardsystem.RewardInfo.matter", "matter", (8 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		private var matter$field:String;

		public function clearMatter():void {
			matter$field = null;
		}

		public function get hasMatter():Boolean {
			return matter$field != null;
		}

		public function set matter(value:String):void {
			matter$field = value;
		}

		public function get matter():String {
			return matter$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.rsId);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.rewardId);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.rewardType);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 4);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.rewardTime);
			for (var rewardGmInfo$index:uint = 0; rewardGmInfo$index < this.rewardGmInfo.length; ++rewardGmInfo$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 5);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.rewardGmInfo[rewardGmInfo$index]);
			}
			if (hasKeepTime) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 6);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, keep_time$field);
			}
			if (hasTitle) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 7);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, title$field);
			}
			if (hasMatter) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 8);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, matter$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var rs_id$count:uint = 0;
			var reward_id$count:uint = 0;
			var reward_type$count:uint = 0;
			var reward_time$count:uint = 0;
			var keep_time$count:uint = 0;
			var title$count:uint = 0;
			var matter$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (rs_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: RewardInfo.rsId cannot be set twice.');
					}
					++rs_id$count;
					this.rsId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (reward_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: RewardInfo.rewardId cannot be set twice.');
					}
					++reward_id$count;
					this.rewardId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					if (reward_type$count != 0) {
						throw new flash.errors.IOError('Bad data format: RewardInfo.rewardType cannot be set twice.');
					}
					++reward_type$count;
					this.rewardType = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 4:
					if (reward_time$count != 0) {
						throw new flash.errors.IOError('Bad data format: RewardInfo.rewardTime cannot be set twice.');
					}
					++reward_time$count;
					this.rewardTime = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 5:
					this.rewardGmInfo.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.msg.rewardsystem.RewardGMInfo()));
					break;
				case 6:
					if (keep_time$count != 0) {
						throw new flash.errors.IOError('Bad data format: RewardInfo.keepTime cannot be set twice.');
					}
					++keep_time$count;
					this.keepTime = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 7:
					if (title$count != 0) {
						throw new flash.errors.IOError('Bad data format: RewardInfo.title cannot be set twice.');
					}
					++title$count;
					this.title = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 8:
					if (matter$count != 0) {
						throw new flash.errors.IOError('Bad data format: RewardInfo.matter cannot be set twice.');
					}
					++matter$count;
					this.matter = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
