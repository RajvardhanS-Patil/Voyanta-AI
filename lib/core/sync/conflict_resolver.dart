abstract class ConflictResolver {
  /// Resolves conflicts between a local item and a server item.
  T resolve<T extends HasTimestamp>({
    required T local,
    required T server,
    required ConflictStrategy strategy,
  });
}

abstract class HasTimestamp {
  DateTime get updatedAt;
}

enum ConflictStrategy { lastWriteWins, mergeList }

class ConflictResolverImpl implements ConflictResolver {
  @override
  T resolve<T extends HasTimestamp>({
    required T local,
    required T server,
    required ConflictStrategy strategy,
  }) {
    switch (strategy) {
      case ConflictStrategy.lastWriteWins:
        // Enforce the Last Write Wins (LWW) protocol by evaluating updated-at dates
        if (local.updatedAt.isAfter(server.updatedAt)) {
          return local;
        }
        return server;
      case ConflictStrategy.mergeList:
        // Returns the local version; actual merges are handled at the repository collection layer
        return local;
    }
  }
}
