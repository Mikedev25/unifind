# unifind

A lost and found campush mobile application system.

*Use this once on Mac*
                        onTap: () async {
                              setState(() => _isLoading = true);
                              try {
                                await AuthService().signInWithApple();
                              } on SignInWithAppleAuthorizationException catch (e) {
                                if (e.code != AuthorizationErrorCode.canceled) {
                                  setState(() => errorMessage = 'Apple Sign-In failed. Please try again.');
                                }
                              } catch (e) {
                                setState(() => errorMessage = 'Apple Sign-In failed. Please try again.');
                              } finally {
                                setState(() => _isLoading = false);
                              }

                              