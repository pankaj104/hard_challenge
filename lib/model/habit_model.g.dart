// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProgressWithStatusAdapter extends TypeAdapter<ProgressWithStatus> {
  @override
  final int typeId = 0;

  @override
  ProgressWithStatus read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProgressWithStatus(
      status: fields[0] as TaskStatus,
      progress: fields[1] as double,
      duration: fields[2] as Duration?,
    );
  }

  @override
  void write(BinaryWriter writer, ProgressWithStatus obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.status)
      ..writeByte(1)
      ..write(obj.progress)
      ..writeByte(2)
      ..write(obj.duration);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ProgressWithStatusAdapter &&
              runtimeType == other.runtimeType &&
              typeId == other.typeId;
}

class HabitAdapter extends TypeAdapter<Habit> {
  @override
  final int typeId = 1;

  @override
  Habit read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Habit(
      title: fields[0] as String,
      category: fields[1] as String,
      habitIcon: fields[2] as IconData,
      iconBgColor: fields[3] as Color,
      notificationTime: (fields[4] as List).cast<String>(),
      taskType: fields[5] as TaskType,
      habitType: fields[7] as HabitType,
      repeatType: fields[6] as RepeatType,
      timer: fields[8] as Duration?,
      value: fields[9] as int?,
      progressJson: (fields[10] as Map).cast<DateTime, ProgressWithStatus>(),
      days: (fields[11] as List?)?.cast<int>(),
      selectedDates: (fields[12] as List?)?.cast<DateTime>(),
      selectedTimesPerWeek: fields[13] as int?,
      selectedTimesPerMonth: fields[14] as int?,
      startDate: fields[15] as DateTime,
      endDate: fields[16] as DateTime?,
      notes: fields[17] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Habit obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.category)
      ..writeByte(2)
      ..write(obj.habitIcon)
      ..writeByte(3)
      ..write(obj.iconBgColor)
      ..writeByte(4)
      ..write(obj.notificationTime)
      ..writeByte(5)
      ..write(obj.taskType)
      ..writeByte(6)
      ..write(obj.repeatType)
      ..writeByte(7)
      ..write(obj.habitType)
      ..writeByte(8)
      ..write(obj.timer)
      ..writeByte(9)
      ..write(obj.value)
      ..writeByte(10)
      ..write(obj.progressJson)
      ..writeByte(11)
      ..write(obj.days)
      ..writeByte(12)
      ..write(obj.selectedDates)
      ..writeByte(13)
      ..write(obj.selectedTimesPerWeek)
      ..writeByte(14)
      ..write(obj.selectedTimesPerMonth)
      ..writeByte(15)
      ..write(obj.startDate)
      ..writeByte(16)
      ..write(obj.endDate)
      ..writeByte(17)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is HabitAdapter &&
              runtimeType == other.runtimeType &&
              typeId == other.typeId;
}



class IconDataAdapter extends TypeAdapter<IconData> {
  @override
  final typeId = 100; // Assign a unique typeId for this adapter

  @override
  IconData read(BinaryReader reader) {
    // Read the codePoint and fontFamily from the reader
    final codePoint = reader.readInt();
    final fontFamily = reader.readString();
    return IconData(codePoint, fontFamily: fontFamily);
  }

  @override
  void write(BinaryWriter writer, IconData obj) {
    // Write the codePoint and fontFamily of IconData to the writer
    writer.writeInt(obj.codePoint);
    writer.writeString(obj.fontFamily ?? '');
  }
}




class MaterialColorAdapter extends TypeAdapter<MaterialColor> {
  @override
  final typeId = 101; // Assign a unique typeId for this adapter

  @override
  MaterialColor read(BinaryReader reader) {
    // Read the color value from the reader
    final colorValue = reader.readInt();
    return MaterialColor(colorValue, <int, Color>{});
  }

  @override
  void write(BinaryWriter writer, MaterialColor obj) {
    // Write the color value (primary color) to the writer
    writer.writeInt(obj[500]?.value ?? 0); // Using the primary color
  }
}

class TaskTypeAdapter extends TypeAdapter<TaskType> {
  @override
  final typeId = 102; // Assign a unique typeId for this adapter

  @override
  TaskType read(BinaryReader reader) {
    // Read an integer value from the binary data and map it to TaskType enum
    int index = reader.readByte();
    return TaskType.values[index];
  }

  @override
  void write(BinaryWriter writer, TaskType obj) {
    // Write the index of the TaskType enum to the binary data
    writer.writeByte(obj.index);
  }
}

class RepeatTypeAdapter extends TypeAdapter<RepeatType> {
  @override
  final typeId = 103; // Assign a unique typeId for this adapter

  @override
  RepeatType read(BinaryReader reader) {
    // Read an integer value from the binary data and map it to RepeatType enum
    int index = reader.readByte();
    return RepeatType.values[index];
  }

  @override
  void write(BinaryWriter writer, RepeatType obj) {
    // Write the index of the RepeatType enum to the binary data
    writer.writeByte(obj.index);
  }
}

class HabitTypeAdapter extends TypeAdapter<HabitType> {
  @override
  final typeId = 104; // Assign a unique typeId for this adapter

  @override
  HabitType read(BinaryReader reader) {
    // Read an integer value from the binary data and map it to HabitType enum
    int index = reader.readByte();
    return HabitType.values[index];
  }

  @override
  void write(BinaryWriter writer, HabitType obj) {
    // Write the index of the HabitType enum to the binary data
    writer.writeByte(obj.index);
  }
}

class TaskStatusAdapter extends TypeAdapter<TaskStatus> {
  @override
  final typeId = 105;  // Make sure this ID is unique for each adapter.

  @override
  TaskStatus read(BinaryReader reader) {
    int index = reader.readByte();
    return TaskStatus.values[index];
  }

  @override
  void write(BinaryWriter writer, TaskStatus obj) {
    writer.writeByte(obj.index);
  }
}

class DurationAdapter extends TypeAdapter<Duration> {
  @override
  final int typeId = 106;  // A unique typeId for Duration

  @override
  Duration read(BinaryReader reader) {
    final seconds = reader.readInt();  // Read the duration in seconds
    return Duration(seconds: seconds);
  }

  @override
  void write(BinaryWriter writer, Duration obj) {
    writer.writeInt(obj.inSeconds);  // Write the duration in seconds
  }
}

class ColorAdapter extends TypeAdapter<Color> {
  @override
  final typeId = 107;  // Make sure this ID is unique

  @override
  Color read(BinaryReader reader) {
    // Hive stores colors as an integer
    int colorValue = reader.readInt();
    return Color(colorValue);
  }

  @override
  void write(BinaryWriter writer, Color obj) {
    // Hive stores colors as an integer
    writer.writeInt(obj.value);
  }
}