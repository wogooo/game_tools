package com.msg.sys {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.msg.sys.ConfigInt;
	import com.msg.sys.ConfigBool;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class CAutoConfigSave extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const CONFIG_BOOL_ARR:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.msg.sys.CAutoConfigSave.config_bool_arr", "configBoolArr", (1 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.msg.sys.ConfigBool; });

		[ArrayElementType("com.msg.sys.ConfigBool")]
		public var configBoolArr:Array = [];

		/**
		 *  @private
		 */
		public static const CONFIG_INT_ARR:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.msg.sys.CAutoConfigSave.config_int_arr", "configIntArr", (2 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.msg.sys.ConfigInt; });

		[ArrayElementType("com.msg.sys.ConfigInt")]
		public var configIntArr:Array = [];

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			for (var configBoolArr$index:uint = 0; configBoolArr$index < this.configBoolArr.length; ++configBoolArr$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 1);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.configBoolArr[configBoolArr$index]);
			}
			for (var configIntArr$index:uint = 0; configIntArr$index < this.configIntArr.length; ++configIntArr$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.configIntArr[configIntArr$index]);
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
					this.configBoolArr.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.msg.sys.ConfigBool()));
					break;
				case 2:
					this.configIntArr.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.msg.sys.ConfigInt()));
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
