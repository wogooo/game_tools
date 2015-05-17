package com.msg.mapScene {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.msg.mapScene.OtherRoleInfo;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class SMonsterBirth extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const MONSTER_INFO:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.msg.mapScene.SMonsterBirth.monster_info", "monsterInfo", (1 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.msg.mapScene.OtherRoleInfo; });

		public var monsterInfo:com.msg.mapScene.OtherRoleInfo;

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.monsterInfo);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var monster_info$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (monster_info$count != 0) {
						throw new flash.errors.IOError('Bad data format: SMonsterBirth.monsterInfo cannot be set twice.');
					}
					++monster_info$count;
					this.monsterInfo = new com.msg.mapScene.OtherRoleInfo();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.monsterInfo);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
