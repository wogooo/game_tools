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
	public dynamic final class SNearTeams extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const NEAR_LEADERS:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.msg.team_pro.SNearTeams.near_leaders", "nearLeaders", (1 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.msg.team_pro.PasserbyInfo; });

		[ArrayElementType("com.msg.team_pro.PasserbyInfo")]
		public var nearLeaders:Array = [];

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			for (var nearLeaders$index:uint = 0; nearLeaders$index < this.nearLeaders.length; ++nearLeaders$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 1);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.nearLeaders[nearLeaders$index]);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					this.nearLeaders.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.msg.team_pro.PasserbyInfo()));
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
