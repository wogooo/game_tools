package com.msg.pvp {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.msg.pvp.PlayerInfo;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class SEnterArena extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const CODE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.pvp.SEnterArena.code", "code", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var code:int;

		/**
		 *  @private
		 */
		public static const PLAYER_INFOS:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.msg.pvp.SEnterArena.player_infos", "playerInfos", (2 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.msg.pvp.PlayerInfo; });

		[ArrayElementType("com.msg.pvp.PlayerInfo")]
		public var playerInfos:Array = [];

		/**
		 *  @private
		 */
		public static const READY_TIME:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.pvp.SEnterArena.ready_time", "readyTime", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		private var ready_time$field:int;

		private var hasField$0:uint = 0;

		public function clearReadyTime():void {
			hasField$0 &= 0xfffffffe;
			ready_time$field = new int();
		}

		public function get hasReadyTime():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set readyTime(value:int):void {
			hasField$0 |= 0x1;
			ready_time$field = value;
		}

		public function get readyTime():int {
			return ready_time$field;
		}

		/**
		 *  @private
		 */
		public static const ARENA_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.pvp.SEnterArena.arena_id", "arenaId", (4 << 3) | com.netease.protobuf.WireType.VARINT);

		public var arenaId:int;

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.code);
			for (var playerInfos$index:uint = 0; playerInfos$index < this.playerInfos.length; ++playerInfos$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.playerInfos[playerInfos$index]);
			}
			if (hasReadyTime) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, ready_time$field);
			}
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 4);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.arenaId);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var code$count:uint = 0;
			var ready_time$count:uint = 0;
			var arena_id$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (code$count != 0) {
						throw new flash.errors.IOError('Bad data format: SEnterArena.code cannot be set twice.');
					}
					++code$count;
					this.code = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					this.playerInfos.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.msg.pvp.PlayerInfo()));
					break;
				case 3:
					if (ready_time$count != 0) {
						throw new flash.errors.IOError('Bad data format: SEnterArena.readyTime cannot be set twice.');
					}
					++ready_time$count;
					this.readyTime = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 4:
					if (arena_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: SEnterArena.arenaId cannot be set twice.');
					}
					++arena_id$count;
					this.arenaId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
