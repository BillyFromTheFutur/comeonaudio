import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../recordings_list/cubit/files/files_cubit.dart';
import 'cubit/record/record_cubit.dart';

// Rien de particulier , le code est assez explicite,
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const routeName = '/homescreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // On utilise le bloc builder pour utilsier la logique de cubit state management
      body: BlocBuilder<RecordCubit, RecordState>(builder: (context, state) {
        return SafeArea(
          child: Center(
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary:
                        (state is RecordOn ? Colors.purple : Colors.amber)),
                onPressed: () {
                  if (state is RecordOn) {
                    context.read<RecordCubit>().stopRecording();

                    ///On recharge les fichier pour les mettres a jours
                    context.read<FilesCubit>().getFiles();
                  } else {
                    context.read<RecordCubit>().startRecording();
                  }
                },
                child: Icon(state is RecordOn ? Icons.stop : Icons.mic)),
          ),
        );
      }),
    );
  }
}
